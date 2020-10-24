import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/tasks.dart';
import 'models/todo.dart';

class DatabaseHelper {

  Future<Database> database() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    return openDatabase(path,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  Future<List<Task>> getTasks() async {

    /* Calling the database */
    Database _db = await database();

    /* List of Maps Containing contents of 'tasks' Table */
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    /* Here index stores the Length of the list */
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'], title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();

    /* await _db.insert(String Table, map<String, dynamic> values, ConflictAlgorithm conflictAlgorithm */
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }



  Future<List<TodoModel>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return TodoModel(id: todoMap[index]['id'], title: todoMap[index]['title'], taskId: todoMap[index]['taskId'], isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> insertTodo(TodoModel todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

}