import 'package:alter_tank/models/fueling_log.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FuelingLogsDatabase {
  static final FuelingLogsDatabase instance = FuelingLogsDatabase._init();
  static Database? _database;

  FuelingLogsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("fuelinglogs.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final integer = 'INTEGER NOT NULL';
    final string = 'TEXT NOT NULL';

    await db.execute('''
        CREATE TABLE $tableFuelLogs(
            ${FuelLogFields.id} $idType,
            ${FuelLogFields.carId} $integer,
            ${FuelLogFields.mileage} $string,
            ${FuelLogFields.cost} $string,
            ${FuelLogFields.units} $string,
            ${FuelLogFields.date} $string
        )
        ''');
  }

  Future<List<FuelLog>> getFuelingLogs(int carId) async {
    final db = await instance.database;
    final result = await db.query(tableFuelLogs,
      where: "${FuelLogFields.carId}=?",
      whereArgs: [carId]
    );
    return result.map((json) => FuelLog.fromJson(json)).toList();
  }

  Future<List<FuelLog>> getLast(int carId) async {
    final db = await instance.database;
    final result = await db.query(tableFuelLogs,
        where: "${FuelLogFields.carId}=?",
        whereArgs: [carId],
        orderBy: "${FuelLogFields.date} DESC",
        limit: 1
    );
    return result.map((json) => FuelLog.fromJson(json)).toList();
  }

  Future close() async{
    final db= await instance.database;
    db.close();
  }
}