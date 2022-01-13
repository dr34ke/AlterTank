const String tableFuelLogs='fuelingLogs';
class FuelLogFields{
  static final List<String> values =[
    id, carId, units, mileage, cost, date, usage
  ];
  static const String id ='_id';
  static const String carId = '_carId';
  static const String units = '_units';
  static const String mileage = '_mileage';
  static const String cost = '_cost';
  static const String date = '_date';
  static const String usage = '_usage';
}

class FuelLog{
  final int? id;
  final int carId;
  final double units;
  final double mileage;
  final double cost;
  final DateTime date;
  final double usage;


  const FuelLog({
    this.id,
    required this.carId,
    required this.units,
    required this.mileage,
    required this.cost,
    required this.date,
    required this.usage,
  });

  FuelLog copy({
    int? id,
    int? carId,
    double? units,
    double? mileage,
    double? cost,
    DateTime? date,
    double? usage,
  }) =>FuelLog(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    units: units ?? this.units,
    mileage: mileage ?? this.mileage,
    cost: cost ?? this.cost,
    date: date ?? this.date,
    usage: usage ?? this.usage,
  );


  Map<String, Object?> toJson() =>{
    FuelLogFields.id: id,
    FuelLogFields.carId: carId,
    FuelLogFields.units: units,
    FuelLogFields.mileage: mileage,
    FuelLogFields.cost: cost,
    FuelLogFields.usage: usage,
    FuelLogFields.date:date.toIso8601String(),
  };
  static FuelLog fromJson(Map<String, Object?> map) => FuelLog(
      id: map[FuelLogFields.id] as int?,
      carId: map[FuelLogFields.carId] as int,
      units: map[FuelLogFields.units] as double,
      mileage: map[FuelLogFields.mileage] as double,
      cost: map[FuelLogFields.cost] as double,
      usage: map[FuelLogFields.usage] as double,
      date: DateTime.parse(map[FuelLogFields.date] as String),
  );
}



