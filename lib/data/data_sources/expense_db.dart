import 'package:interview_task/data/data_sources/database_service.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDb {
  final tableName = 'expense';
  final tableName2 = 'expenseType';
  
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
        expenseType INTEGER,  -- Define the foreign key column
        FOREIGN KEY (expenseType) REFERENCES $tableName2 (id)
      )
      '''
    );
  }
  
  Future<int> createExpense ({required Expense expense}) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, expense.toMap());
  }
  
  Future<int> createExpenseType ({required ExpenseType expenseType}) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName2, {
      'name' : expenseType.name,
    });
  }
  
  Future<List<Expense>> getAllExpenseWithTypes() async {
    final Database database = await DatabaseService().database;
    final expensesList = await database.rawQuery(
      '''
        SELECT expense.*, expenseType.name AS expenseTypeName
        FROM $tableName
        INNER JOIN $tableName2
        ON expense.expenseType = expenseType.id 
      '''
    );
    return expensesList.map((expense) => Expense.fromMap(expense)).toList();
  }
  
  Future<List<ExpenseType>> getExpenseTypes() async {
    final Database database = await DatabaseService().database;
    final expenseTypes = await database.query(tableName2);
    return expenseTypes.map((expenseType) => ExpenseType.fromMap(expenseType)).toList();
  }
}
