import 'package:alter_tank/models/fuel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FuelDatabase{
  static final FuelDatabase instance = FuelDatabase._init();
  static Database? _database;
  FuelDatabase._init();
  Future<Database> get database async{
    if(_database!=null) return _database!;

    _database = await _initDB("fuel.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);

    return await openDatabase(path, version:1, onCreate: _createDB);
  }
  Future _createDB(Database db, int version)async{
    final idType='INTEGER PRIMARY KEY AUTOINCREMENT';
    final integer='INTEGER NOT NULL';
    final string='TEXT NOT NULL';

    await db.execute('''
        CREATE TABLE $tableFuel(
            ${FuelFields.id} $idType,
            ${FuelFields.name} $string,
            ${FuelFields.unit} $string,
            ${FuelFields.plugType} $string
        )
        ''');
    await db.execute('''
        INSERT INTO $tableFuel(
            ${FuelFields.id},
            ${FuelFields.name},
            ${FuelFields.unit},
            ${FuelFields.plugType}
        ) 
        VALUES 
        (1,'Elektryczny', 'kw/h', 'Rodzaj złącza tankowania'),
        (2,'CNG', 'l', ''),
        (3,'LNG', 'l', ''),
        (4,'H2','kg','Ciśnienie Tankowania')
        ''');

    await db.execute('''
        CREATE TABLE $tablePlug(
            ${PlugFields.id} $idType,
            ${PlugFields.fuelId} $integer,
            ${PlugFields.name} $string
        )
        ''');
    await db.execute('''
        INSERT INTO $tablePlug(
            ${PlugFields.id},
            ${PlugFields.fuelId},
            ${PlugFields.name}
        ) 
        VALUES 
        (1,1,'CCS/SAE'),
        (2,1,'CHAdeMo'),
        (3,1,'J-1772'),
        (4,1,'Tesla'),
        (5,1,'Tesla (fast)'),
        (6,1,'Tesla(Roadster)'),
        (7,1,'Type 2'),
        (8,1,'Type 3'),
        (9,1,'Three Phase'),
        (10,1,'Caravan Mains Socket'),
        (11,1,'Gniazdo elektryczne'),
        (12,4,'350 bar'),
        (13,4,'700 bar')
        ''');
  }
  Future<Fuel> getFuel(int id) async{
    final db = await  instance.database;
    final maps = await db.query(
      tableFuel,
      columns: FuelFields.values,
      where: '${FuelFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty){
      return Fuel.fromJson(maps.first);
    }
    else{
      throw Exception('Typ paliwa $id nie znaleziony');
    }
  }
  Future<List<Fuel>> getFuels() async{
    final db = await  instance.database;
    final result = await db.query(tableFuel);

    return result.map((json) => Fuel.fromJson(json)).toList();
  }


  Future<Plug> getPlug(int id) async{
    final db = await  instance.database;
    final maps = await db.query(
      tablePlug,
      columns: PlugFields.values,
      where: '${PlugFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty){
      return Plug.fromJson(maps.first);
    }
    else{
      throw Exception('Pojazd $id nie znaleziony');
    }
  }
  Future<List<Plug>> getPlugs(String fuelId) async{
    final db = await  instance.database;
    final result = await db.query(
        tablePlug,
        where: '${PlugFields.fuelId}=?',
        whereArgs: [fuelId],
    );
    return result.map((json) => Plug.fromJson(json)).toList();
  }

  Future close() async{
    final db= await instance.database;
    db.close();
  }

}