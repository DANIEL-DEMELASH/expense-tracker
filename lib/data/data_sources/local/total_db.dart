import 'package:interview_task/data/data_sources/local/database_service.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:sqflite/sqflite.dart';

class TotalDb {
  final String tableName = 'monthly_summary';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        month TEXT NOT NULL,
        totalIncome REAL NOT NULL,
        totalExpense REAL NOT NULL,
        balance REAL NOT NULL,
        currency TEXT NOT NULL
      )
    ''');
  }

  Future<int> create({required Total total}) async {
    final Database database = await DatabaseService().database;
    return await database.insert(tableName, total.toMap());
  }

  Future<List<Total>> getAllTotals() async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> totalsList = await database.query(tableName);
    return totalsList.map((total) => Total.fromMap(total)).toList();
  }

  Future<Total> getById(int id) async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> total = await database.query(tableName, where: 'id = ?', whereArgs: [id]);
    return total.map((total) => Total.fromMap(total)).first;
  }

  Future<int> updateIncome({required Income income}) async {
    final Database database = await DatabaseService().database;

    await _ensureRecordExists(income.createdDate!);

    return await database.rawUpdate('''
      UPDATE $tableName 
      SET 
        totalIncome = totalIncome + ?,
        balance = totalIncome + ? - totalExpense
      WHERE month = ?
    ''', [income.amount, income.amount, income.createdDate]);
  }

  Future<int> updateExpense({required Expense expense}) async {
    final Database database = await DatabaseService().database;

    await _ensureRecordExists(expense.createdDate!);

    return await database.rawUpdate('''
      UPDATE $tableName 
      SET 
        totalExpense = totalExpense + ?,
        balance = totalIncome - ( ? + totalExpense )
      WHERE month = ?
    ''', [expense.amount, expense.amount, expense.createdDate]);
  }

  Future<void> deleteAllRecords() async {
    final Database database = await DatabaseService().database;
    await database.delete(tableName);
  }

  Future<bool> recordExists(String month) async {
    final Database database = await DatabaseService().database;
    final List<Map<String, dynamic>> result = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM $tableName WHERE month = ?',
      [month],
    );
    return result.isNotEmpty && result.first['count'] > 0;
  }

  Future<void> _ensureRecordExists(String month) async {
    if (!await recordExists(month)) {
      await create(
        total: Total(
          month: month,
          totalIncome: 0.0,
          totalExpense: 0.0,
          balance: 0.0,
          currency: 'ETB',
        ),
      );
    }
  }
}
