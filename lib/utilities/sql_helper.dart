import 'dart:async' as prefix0;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:jobnote/models/notes.dart';

class SQL_Helper{

  // create instant from same class
  static SQL_Helper dbHelper;
  static Database _database; // name of database

  SQL_Helper._createInstance();

  // use factory to return value
  factory SQL_Helper(){
    if(dbHelper == null){
      dbHelper = SQL_Helper._createInstance();
    }
    return dbHelper;
  }

  // initalize table name and columns names to can use
  String tableName = "Notes_table";

  String _id = "id";
  String _name = "name";
  String _description = "description";
  String _pass = "pass";
  String _date = "date";

  // this method to can return database
  Future<Database> get database async{
    if(_database == null){
      _database = await initalizeDataBase();
    }
    return _database;
  }

  // this function to initalize database from path (create database)
  Future<Database> initalizeDataBase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    var studentDB = await openDatabase(path, version: 1, onCreate: createDatabase);
    return studentDB;
  }

  // function create tables inside database
  void createDatabase(Database db, int version)async{
    await db.execute("CREATE TABlE $tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT,"
        " $_description TEXT, $_pass INTEGER, $_date TEXT) ");
  }


  // return list of tables from database
  Future<List<Map<String, dynamic>>> getStudentMapList()async{
    Database db = await this.database;
    // var result = await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName, orderBy: "$_id ASC");
    return result;
  }

  // insert into database, return number of rows are added
  Future<int> insertStudent(Notes student)async {
    Database db = await this.database;
    var result = await db.insert(tableName, student.toMap());
    return result;
  }

  // update function, return number of rows are updated
  Future<int> updateStudent(Notes student) async {
    Database db = await this.database;
    var result = await db.update(tableName, student.toMap(), where: "$_id = ?", whereArgs: [student.id]);
    return result;
  }

  // delete function, you can use db.rawDelete or db.delete
  Future<int> deleteNotes(int id) async {
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM $tableName WHERE $_id = $id");
    return result;
  }

  // return count of rows
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> all = await db.rawQuery("SELECT COUNT (*) FROM $tableName");
    // to get value from all variable
    int result = Sqflite.firstIntValue(all);
    return result;
  }

  // to use in studen_list to return all students in list instead of map
  Future<List<Notes>> getStudentList() async {
    var studentMapList = await getStudentMapList();
    int count = studentMapList.length;
    List<Notes> students = new List<Notes>();
    for(int i=0; i <= count-1; i++){
      students.add(Notes.getMap(studentMapList[i]));
    }
    return students;
  }


}
