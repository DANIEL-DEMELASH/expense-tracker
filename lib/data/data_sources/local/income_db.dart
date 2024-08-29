import 'package:interview_task/data/data_sources/local/database_service.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDb {
  final String tableName = 'income';
  final String tableName2 = 'incomeType';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        note TEXT,
        createdDate TEXT NOT NULL,
        incomeType INTEGER,
        FOREIGN KEY (incomeType) REFERENCES $tableName2 (id)
      )
    ''');
    
    await database.transaction((txn) async {
      await txn.rawInsert(
        '''
        INSERT INTO $tableName2 (name) VALUES (?)
        ''',
        ['Salary']
      );
      await txn.rawInsert(
        '''
        INSERT INTO $tableName2 (name) VALUES (?)
        ''',
        ['Bonus']
      );
    });
  }

  Future<int> createIncomeType({required IncomeType incomeType}) async {
    final Database database = await DatabaseService().database;
    return await database.insert(tableName2, {'name': incomeType.name});
  }

  Future<int> createIncome({required Income income}) async {
    final Database database = await DatabaseService().database;
    final TotalDb totalDb = TotalDb();
    bool recordExists = false;
    
    final List<Income> allIncomes = await getAllIncomeWithTypes();
    for(var inc in allIncomes){
     if(inc.createdDate == income.createdDate && inc.incomeType == income.incomeType){
      
      await database.rawUpdate('''
        UPDATE $tableName 
        SET 
          amount = amount + ?
        WHERE createdDate = ? AND incomeType = ?
        ''', 
        [income.amount, income.createdDate, income.incomeType]);

      recordExists = true;
      break;
     }
     
    }
    
    if(!recordExists){
      await database.insert(tableName, income.toMap());  
    }
    return await totalDb.updateIncome(income: income);
  }

  Future<List<Income>> getAllIncomeWithTypes() async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> incomesList = await database.rawQuery('''
      SELECT income.*, incomeType.name AS incomeTypeName
      FROM $tableName
      INNER JOIN $tableName2 ON income.incomeType = incomeType.id
    ''');
    
    return incomesList.map((income) => Income.fromMap(income)).toList();
  }

  Future<List<IncomeType>> getIncomeTypes() async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> incomeTypes = await database.query(tableName2);
    
    return incomeTypes.map((incomeType) => IncomeType.fromMap(incomeType)).toList();
  }

  Future<List<Income>> getIncomeWithTypesByMonth(int id) async {
    final TotalDb totalDb = TotalDb();
    final Total total = await totalDb.getById(id);
    final String formattedDate = total.month!;
    final List<Income> incomesList = await getAllIncomeWithTypes();

    return incomesList.where((income) => income.createdDate == formattedDate).toList();
  }
}
