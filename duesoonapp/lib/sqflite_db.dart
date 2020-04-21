import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:duesoonapp/task.dart';

class SQLDatabase
{
  static SQLDatabase _sqlDb;
  static Database _db;

  SQLDatabase._createInstance();

  // database table elements
  String taskTable = 'note_table';
  String colId = 'id';
  String colTaskName = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';


  factory SQLDatabase() {
    if (_sqlDb == null) {
      _sqlDb = SQLDatabase._createInstance();
    }
    return _sqlDb;
  }

  Future<Database> get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  // will locate where in iOS and Android device to create the database
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTaskName TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(taskTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> addTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    var db = await this.database;
    var result = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $taskTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $taskTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    var taskMapList = await getNoteMapList();
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }
}
