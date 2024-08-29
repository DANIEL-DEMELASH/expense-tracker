import 'package:interview_task/data/data_sources/local/database_service.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDb {
  final String tableName = 'expense';
  final String tableName2 = 'expenseType';

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
        expenseType INTEGER,
        FOREIGN KEY (expenseType) REFERENCES $tableName2 (id)
      )
    ''');
    
     await database.transaction((txn) async {
      await txn.rawInsert(
        '''
        INSERT INTO $tableName2 (name) VALUES (?)
        ''',
        ['Food']
      );
      await txn.rawInsert(
        '''
        INSERT INTO $tableName2 (name) VALUES (?)
        ''',
        ['Transport']
      );
      await txn.rawInsert(
        '''
        INSERT INTO $tableName2 (name) VALUES (?)
        ''',
        ['Rent']
      );
    });


  }

  Future<int> createExpense({required Expense expense}) async {
    final Database database = await DatabaseService().database;
    final TotalDb totalDb = TotalDb();
    
    bool recordExists = false;
    
    final List<Expense> allExpenses = await getAllExpenseWithTypes();
    for(var ex in allExpenses){
     if(ex.createdDate == expense.createdDate && ex.expenseType == expense.expenseType){
      
      await database.rawUpdate('''
        UPDATE $tableName 
        SET 
          amount = amount + ?
        WHERE createdDate = ? AND expenseType = ?
        ''', 
        [expense.amount, expense.createdDate, expense.expenseType]);

      recordExists = true;
      break;
     }
     
    }
    
    if(!recordExists){
      await database.insert(tableName, expense.toMap());  
    }
    return totalDb.updateExpense(expense: expense);
  }

  Future<int> createExpenseType({required ExpenseType expenseType}) async {
    final Database database = await DatabaseService().database;
    return database.insert(tableName2, expenseType.toMap());
  }

  Future<List<Expense>> getAllExpenseWithTypes() async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> expensesList = await database.rawQuery('''
      SELECT expense.*, expenseType.name AS expenseTypeName
      FROM $tableName
      INNER JOIN $tableName2 ON expense.expenseType = expenseType.id
    ''');
    
    return expensesList.map((expense) => Expense.fromMap(expense)).toList();
  }

  Future<List<ExpenseType>> getExpenseTypes() async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> expenseTypes = await database.query(tableName2);
    
    return expenseTypes.map((expenseType) => ExpenseType.fromMap(expenseType)).toList();
  }

  Future<List<Expense>> getExpenseWithTypesByMonth(int id) async {
    final TotalDb totalDb = TotalDb();
    final Total total = await totalDb.getById(id);
    final String formattedDate = total.month!;
    final List<Expense> expensesList = await getAllExpenseWithTypes();

    return expensesList.where((expense) => expense.createdDate == formattedDate).toList();
  }

}
