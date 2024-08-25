import 'package:interview_task/data/data_sources/database_service.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDb {
  final tableName = 'income';
  final tableName2 = 'incomeType';
  
  Future<void> createTable(Database database) async {
    await database.execute(
      '''
      CREATE TABLE IF NOT EXISTS $tableName2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL
      )
      '''
    );
    
    await database.execute(
      '''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        note TEXT,
        createdDate TEXT NOT NULL,
        incomeType INTEGER,  -- Define the foreign key column
        FOREIGN KEY (incomeType) REFERENCES $tableName2 (id)
      )
      '''
    );
  }
  
  Future<int> createIncomeType ({required IncomeType incomeType}) async {
    final Database database = await DatabaseService().database;
    return await database.insert(tableName2, {
      'name' : incomeType.name
    });
  }
  
  Future<int> createIncome ({required Income income}) async {
    final Database database = await DatabaseService().database;
    return await database.insert(tableName, income.toMap());
  }
    
  Future<List<Income>> getAllIncomeWithTypes() async {
    final Database database = await DatabaseService().database;
    final incomesList = await database.rawQuery(
      '''
        SELECT income.*, incomeType.name AS incomeTypeName
        FROM $tableName
        INNER JOIN $tableName2
        ON income.incomeType = incomeType.id 
      '''
    );
    return incomesList.map((income) => Income.fromMap(income)).toList();
  }
  
  Future<List<IncomeType>> getIncomeTypes() async {
    final Database database = await DatabaseService().database;
    final incomeTypes = await database.query(tableName2);
    return incomeTypes.map((incomeType) => IncomeType.fromMap(incomeType)).toList();
  }
  
  Future<List<Income>> getIncomeWithTypesByMonth(String month) async {
    final Database database = await DatabaseService().database;
    final incomesList = await database.rawQuery(
      '''
        SELECT income.*, incomeType.name AS incomeTypeName
        FROM $tableName
        INNER JOIN $tableName2
        ON income.incomeType = incomeType.id 
        WHERE income.createdDate = ?
      ''',
      [month]
    );
    return incomesList.map((income) => Income.fromMap(income)).toList();
  }
  
}
