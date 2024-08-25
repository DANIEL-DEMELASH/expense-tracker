import 'package:interview_task/data/data_sources/database_service.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:sqflite/sqflite.dart';

class TotalDb {
  final tableName = 'monthly_summary';

  Future<void> createTable(Database database) async {
    await database.execute(
      '''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        month TEXT NOT NULL,
        totalIncome REAL NOT NULL,
        totalExpense REAL NOT NULL,
        balance REAL NOT NULL,
        currency TEXT NOT NULL
      )
      '''
    );
  }
  
  Future<int> create ({required Total total}) async {
    final Database database = await DatabaseService().database;
    return await database.insert(tableName, total.toMap());
  }

  Future<List<Total>> getAllTotals() async {
    final Database database = await DatabaseService().database;
    final totalsList = await database.query(tableName);
    return totalsList.map((total) => Total.fromMap(total)).toList();
  }
}
