import 'dart:io';

import 'package:whizz/models/task_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelpers {
  static final DatabaseHelpers instance = DatabaseHelpers._instance();
  DatabaseHelpers._instance();

  static Database _db;

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colCompleted = 'completed';

  // Task Table
  // Id	|	Title	|	Date |	Priority |	Completed |
  // 0  |  ''   |  ''  |    ''     |   false    |
  // 1  |  ''   |  ''  |    ''     |   false    |
  // 2  |  ''   |  ''  |    ''     |   false    |

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'tasks_v1.db';
    final taskDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return taskDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute('' +
        'CREATE TABLE $taskTable' +
        '($colId INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '$colTitle TEXT, ' +
        '$colDate TEXT, ' +
        '$colPriority TEXT, ' +
        '$colCompleted BOOLEAN)');
  }

  Future<List<Map<String, dynamic>>> getTasksMap() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> taskMap = await db.query(taskTable);

    return taskMap;
  }

  Future<List<TaskModel>> getTasks() async {
    final List<Map<String, dynamic>> tasksMap = await getTasksMap();
    final List<TaskModel> tasks = tasksMap.map((task) {
      return TaskModel.fromJsonMap(task);
    }).toList();

    return tasks;
  }

  Future<int> insertTask(TaskModel task) async {
    Database db = await this.db;
    final int createdId = await db.insert(taskTable, task.toJsonMap());

    return createdId;
  }

  Future<int> updateTask(TaskModel task) async {
    Database db = await this.db;
    final int updatedId = await db.update(taskTable, task.toJsonMap(),
        where: '$colId = ?', whereArgs: [task.id]);

    return updatedId;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int deletedId =
        await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);

    return deletedId;
  }
}
