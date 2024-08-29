import 'package:interview_task/data/data_sources/local/expense_db.dart';
import 'package:interview_task/data/data_sources/local/income_db.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;
  
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    
    _database = await _initialize();
    return _database!;
  }
  
  Future<String> get fullPath async {
    const name = 'monefy.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }
  
  Future<void> create (Database database, int version) async {
    await IncomeDb().createTable(database);
    await ExpenseDb().createTable(database);
    await TotalDb().createTable(database);
  }
  
  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path, version: 1, onCreate: create ,singleInstance: true);
    
    return database;
  }
}