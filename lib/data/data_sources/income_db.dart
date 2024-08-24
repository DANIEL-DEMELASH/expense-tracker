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
  
  Future<List<Income>> getAllIncome () async {
    final Database database = await DatabaseService().database;
    final incomesList = await database.query(tableName);
    return incomesList.map((income) => Income.fromMap(income)).toList();
  }
}
