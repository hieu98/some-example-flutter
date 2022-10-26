import 'dart:io';

import 'package:flutter_app/Model/JobModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "JobDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Job ("
          "id INTEGER PRIMARY KEY,"
          "job_name TEXT,"
          "is_check INTEGER"
          ")");
    });
  }

  deleteDB() async{
    final db = await database;
    var res = await db.rawDelete(
      "DROP DATABASE JobDB"
    );
    return res;
  }

  newJob(Job job) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Job");
    var id = table.first["id"];
    var res = await db.rawInsert(
        "INSERT Into Job (id,job_name,is_check)"
        " VALUES (?,?,0)",
        [id, job.jobName]);
    return res;
  }

  getJob(int id) async{
    final db = await database;
    var res = await db.query("Job", where: "id= ?", whereArgs: [id]);
    return res.isNotEmpty ? Job.fromMap(res.first) : Null;
  }

  Future<Iterable<Job>?> getListCheck() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Job WHERE is_check = 1");
    Iterable<Job>? list = res.isNotEmpty ? res.toList().map((e) => Job.fromMap(e)) : null;
    return list;
  }

  Future<List<Job>> getAllJob() async{
    final db = await database;
    var res = await db.query("Job");
    List<Job> list= res.isNotEmpty ? res.map((e) => Job.fromMap(e)).toList() : [];
    return list;
  }

  deleteJob(int id) async{
    final db = await database;
    db.delete("Job", where: "id = ?", whereArgs: [id]);
  }

  deleteListJob(List<int> list) async {
    for (var element in list) {
      deleteJob(element);
    }
  }

  deleteAll() async{
    final db = await database;
    db.rawDelete("Delete * from Job");
  }

  updateJob(Job job) async{
    final db = await database;
    var res = await db.update("Job", job.toMap(),
      where: "id = ?", whereArgs: [job.id]);
    return res;
  }

  checkJob(Job job) async{
    final db = await database;
    Job checked = Job(
      id: job.id,
      jobName: job.jobName,
      isChecked: job.isChecked
    );
    var res = await db.update("Job", checked.toMap(),
      where: "id =?", whereArgs: [job.id]);
    return res;
  }
}
