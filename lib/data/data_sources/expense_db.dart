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
  
  Future<List<Expense>> getAllExpense() async {
    final Database database = await DatabaseService().database;
    final expensesList = await database.query(tableName);
    return expensesList.map((expense) => Expense.fromMap(expense)).toList();
  }
}
