final String tableFuelLogs='fuelingLogs';
class FuelLogFields{
  static final List<String> values =[
    id, carId, units, mileage, cost, date
  ];
  static final String id ='_id';
  static final String carId = '_carId';
  static final String units = '_units';
  static final String mileage = '_mileage';
  static final String cost = '_cost';
  static final String date = '_date';
}

class FuelLog{
  final int? id;
  final int carId;
  final String units;
  final String mileage;
  final String cost;
  final DateTime date;

  const FuelLog({
    this.id,
    required this.carId,
    required this.units,
    required this.mileage,
    required this.cost,
    required this.date,
  });

  FuelLog copy({
    int? id,
    int? carId,
    String? units,
    String? mileage,
    String? cost,
    DateTime? date,
  }) =>FuelLog(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    units: units ?? this.units,
    mileage: mileage ?? this.mileage,
    cost: cost ?? this.cost,
    date: date ?? this.date,
  );


  Map<String, Object?> toJson() =>{
    FuelLogFields.id: id,
    FuelLogFields.carId: carId,
    FuelLogFields.units: units,
    FuelLogFields.mileage: mileage,
    FuelLogFields.cost: cost,
    FuelLogFields.date:date.toIso8601String(),
  };
  static FuelLog fromJson(Map<String, Object?> map) => FuelLog(
      id: map[FuelLogFields.id] as int?,
      carId: map[FuelLogFields.carId] as int,
      units: map[FuelLogFields.units] as String,
      mileage: map[FuelLogFields.mileage] as String,
      cost: map[FuelLogFields.cost] as String,
      date: DateTime.parse(map[FuelLogFields.date] as String),
  );
}



