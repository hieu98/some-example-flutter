import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/WeatherModel.dart';

class DBWeather {
  DBWeather._();

  static final DBWeather db = DBWeather._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "WeatherDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Weather ("
              "id INTEGER PRIMARY KEY,"
              "temperature INTEGER,"
              "temp_feels_like INTEGER,"
              "country TEXT,"
              "area_name TEXT,"
              "date TEXT,"
              "weather_icon TEXT,"
              "weather_main TEXT,"
              "wind_speed DOUBLE,"
              "humidity DOUBLE,"
              "time_now DOUBLE"
              ")");
        });
  }

  newWeather(Weather1 weather) async {
    deleteWeather(1);
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Weather");
    var id = table.first["id"];
    var res = await db.rawInsert(
        "INSERT Into Weather (id,temperature,temp_feels_like,country,area_name,date,weather_icon,weather_main,wind_speed,humidity,time_now)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [id, weather.temperature, weather.tempFeelsLike, weather.country, weather.areaName, weather.date, weather.weatherIcon, weather.weatherMain, weather.windSpeed, weather.humidity, weather.timeNow]);
    return res;
  }

  getWeather(int id) async {
    final db = await database;
    var res =await  db.query("Weather", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Weather1.fromMap(res.first) : Null ;
  }

  deleteWeatherTable()async{
    final db= await database;
    db.execute("DROP TABLE IF EXISTS Weather");
  }

  Future<List<Weather1>> getAll() async{
    final db = await database;
    var res = await db.query("Weather");
    List<Weather1> list= res.isNotEmpty ? res.map((e) => Weather1.fromMap(e)).toList() : [];
    return list;
  }

  deleteWeather(int id) async{
    final db = await database;
    db.delete("Weather", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async{
    final db = await database;
    db.rawDelete("Delete * FROM Weather");
  }

  updateWeather(Weather1 weather) async{
    final db = await database;
    var res = await db.update("Weather", weather.toMap(),
        where: "id = ?", whereArgs: [weather.id]);
    return res;
  }
}
