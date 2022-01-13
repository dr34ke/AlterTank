import 'package:alter_tank/models/car.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CarsDatabase{
    constructor(){

    }
    static final CarsDatabase instance = CarsDatabase._init();
    static Database? _database;
    CarsDatabase._init();
    Future<Database> get database async{
        if(_database!=null) return _database!;

        _database = await _initDB("cars.db");
        return _database!;
    }

    Future<Database> _initDB(String filePath) async {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath,filePath);

        return await openDatabase(path, version:1, onCreate: _createDB);
    }
    Future _createDB(Database db, int version)async{
        const idType='INTEGER PRIMARY KEY AUTOINCREMENT';
        const string='TEXT NOT NULL';
        const integer='INTEGER NOT NULL';

        await db.execute('''
        CREATE TABLE $tableCars(
            ${CarFields.id} $idType,
            ${CarFields.name} $string,
            ${CarFields.type} $integer,
            ${CarFields.plug} $integer,
            ${CarFields.mileage} $integer,
            ${CarFields.capacity} $integer
        )
        ''');
    }
    Future<Car> getCar(int id) async{
        final db = await  instance.database;
        final maps = await db.query(
            tableCars,
            columns: CarFields.values,
            where: '${CarFields.id} = ?',
            whereArgs: [id]
        );
        if(maps.isNotEmpty){
            return Car.fromJson(maps.first);
        }
        else{
            throw Exception('Pojazd $id nie znaleziony');
        }
    }
    Future<List<Car>> getCars() async{
        final db = await  instance.database;
        final result = await db.query(tableCars);
        
        return result.map((json) => Car.fromJson(json)).toList();
    }

    Future<int> updateCar(Car car) async{
        final db = await  instance.database;
        return db.update(
            tableCars,
            car.toJson(),
            where: '${CarFields.id} = ?',
            whereArgs: [car.id]
        );
    }


    Future<int> deleteCar(int id) async{
        final db = await  instance.database;
        
        return await db.delete(
            tableCars,
            where: '${CarFields.id}= ?',
            whereArgs: [id],
        );
    }

    Future<Car> create(Car car) async{
        final db = await instance.database;

        final id = await db.insert(tableCars, car.toJson());
        return car.copy(id:id);
    }

    Future close() async{
        final db= await instance.database;
        db.close();
    }

}