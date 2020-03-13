import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'corona_cache.db';

    // Open/create the database at a given path
    var coronaDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return coronaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE Cache(id INTEGER PRIMARY KEY AUTOINCREMENT, json TEXT, timestamp TEXT)");
  }

  Future<String> getCache() async {
    var db = await this.database;
    List<Map> cache = await db.rawQuery('SELECT * FROM Cache');
    return cache[0]["json"];
  }

  Future<int> insertCache(String json) async {
    var db = await this.database;

    await _clearCache();
    var timestamp = DateTime.now().toIso8601String();
    var row = {
      'json': json,
      'timestamp': timestamp
    };
    var result = await db.insert('Cache', row);
    return result;
  }

  _clearCache() async {
    var db = await this.database;
    await db.delete("Cache");
  }

  Future<bool> cacheIsOld() async {
    var db = await this.database;
    var result = await db.rawQuery('SELECT timestamp FROM Cache');
    var timestampString = result[0]['timestamp'];
    var timestamp = DateTime
        .parse(timestampString)
        .millisecondsSinceEpoch;

    var nowInMillis = DateTime
        .now()
        .millisecondsSinceEpoch;

    int lastUpdated = nowInMillis - timestamp;
    var lastUpdatedInMinutes = (lastUpdated / 1000) / 60;
    print("Database helper: Cache validity in minutes: " + lastUpdatedInMinutes.toString());
    return lastUpdated > 3600000; //older than an hour
  }

  Future<bool> cacheIsClear() async {
    var db = await this.database;
    var count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Cache'));
    print("Database helper: Cache count: " + count.toString());
        return count == 0;
    }
}
