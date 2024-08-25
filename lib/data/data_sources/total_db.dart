import 'package:interview_task/data/data_sources/database_service.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
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
  
  Future<int> updateIncome ({required Income income}) async {
    final Database database = await DatabaseService().database;
    
    final bool isRecordExist = await recordExists(income.createdDate!);
    
    if(!isRecordExist){
      await create(total: Total(
        month: income.createdDate,
        totalExpense: 0.0,
        totalIncome: 0.0,
        balance: 0.0,
        currency: 'ETB'
      ));
    }
    
    return await database.rawUpdate(
      '''
        UPDATE $tableName 
        SET 
          totalIncome = totalIncome + ?,
          balance = totalIncome + ? - totalExpense
        WHERE month = ?
      ''',
      [income.amount, income.amount, income.createdDate]
    );
    
  }
  
  Future<int> updateExpense ({required Expense expense}) async {
    final Database database = await DatabaseService().database;
    
    final bool isRecordExist = await recordExists(expense.createdDate!);
    
    if(!isRecordExist){
      await create(total: Total(
        month: expense.createdDate,
        totalExpense: 0.0,
        totalIncome: 0.0,
        balance: 0.0,
        currency: 'ETB'
      ));
    }
    
    return await database.rawUpdate(
      '''
        UPDATE $tableName 
        SET 
          totalExpense = totalExpense + ?,
          balance = totalIncome - ( ? + totalExpense )
        WHERE month = ?
      ''',
      [expense.amount, expense.amount, expense.createdDate]
    );
    
  }
  
  Future<void> deleteAllRecords() async {
    final Database database = await DatabaseService().database;

    await database.execute('DELETE FROM $tableName');
  }
  
  Future<bool> recordExists(String month) async {
    final Database database = await DatabaseService().database;

    // Execute the query to check if the record exists
    final List<Map<String, dynamic>> result = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM $tableName WHERE month = ?',
      [month],
    );

    // Check if the count is greater than 0
    return result.isNotEmpty && result.first['count'] > 0;
  }

  Future<List<String>> getDistinctMonths() async {
    final Database database = await DatabaseService().database;

    // Execute the query to fetch distinct months
    final List<Map<String, dynamic>> result = await database.rawQuery(
      'SELECT DISTINCT month FROM $tableName'
    );

    // Extract the month values from the result
    return result.map((row) => row['month'] as String).toList();
  }


}
