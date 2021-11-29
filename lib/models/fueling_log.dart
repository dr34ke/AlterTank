final String tableFuel='fuelingLogs';
class FuelLogFields{
  static final List<String> values =[
    id, carId, units, mileage, cost
  ];
  static final String id ='_id';
  static final String carId = '_carId';
  static final String units = '_units';
  static final String mileage = '_mileage';
  static final String cost = '_cost';
}

class FuelLog{
  final int? id;
  final int carId;
  final String units;
  final String mileage;
  final String cost;

  const FuelLog({
    this.id,
    required this.carId,
    required this.units,
    required this.mileage,
    required this.cost,
  });

  FuelLog copy({
    int? id,
    int? carId,
    String? units,
    String? mileage,
    String? cost,
  }) =>FuelLog(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    units: units ?? this.units,
    mileage: mileage ?? this.mileage,
    cost: cost ?? this.cost,
  );


  Map<String, Object?> toJson() =>{
    FuelLogFields.id: id,
    FuelLogFields.carId: carId,
    FuelLogFields.units: units,
    FuelLogFields.mileage: mileage,
    FuelLogFields.cost: cost,
  };
  static FuelLog fromJson(Map<String, Object?> map) => FuelLog(
      id: map[FuelLogFields.id] as int?,
      carId: map[FuelLogFields.carId] as int,
      units: map[FuelLogFields.units] as String,
      mileage: map[FuelLogFields.mileage] as String,
      cost: map[FuelLogFields.cost] as String
  );
}



