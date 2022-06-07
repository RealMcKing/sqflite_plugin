import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/student.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static late Database _database;

  String studentTable = 'Students';
  String columnId = 'id';
  String columnName = 'name';

  Future<Database> get database async {
    //if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'Student.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $studentTable($columnId INT PRIMARY KEY AUTOINCREMENT, $columnName TEXT)'
    );
  }

  Future<List<Student>> getStudents() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> studentsMapList =
    await db.query(studentTable);
    final List<Student> studentsList = [];
    studentsMapList.forEach((studentMap) {
      studentsList.add(Student.fromMap(studentMap));
    });
    return studentsList;
  }

  Future<Student> insertStudent(Student student) async {
    Database db = await this.database;
    student.id = await db.insert(studentTable, student.toMap());
    return student;
  }

  Future<int> updateStudent(Student student) async {
    Database db = await this.database;
    return await db.update(
      studentTable,
      student.toMap(),
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int? id) async {
    Database db = await this.database;
    return await db.delete(
      studentTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
