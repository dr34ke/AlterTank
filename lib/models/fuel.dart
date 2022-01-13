const String tableFuel='fuelTypes';
class FuelFields{
  static final List<String> values =[
    id, name, unit, plugType
  ];

  static const String id ='_id';
  static const String name = '_name';
  static const String unit = '_unit';
  static const String plugType = '_plugType';
}

class Fuel{
  final int? id;
  final String name;
  final String unit;
  final String plugType;

  const Fuel({
    this.id,
    required this.name,
    required this.unit,
    required this.plugType,
  });

  Fuel copy({
    int? id,
    String? name,
    String? unit,
    String? plugType,
  }) =>Fuel(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    plugType: plugType ?? this.plugType,
  );


  Map<String, Object?> toJson() =>{
    FuelFields.id: id,
    FuelFields.name: name,
    FuelFields.unit: unit,
    FuelFields.plugType: plugType,
  };
  static Fuel fromJson(Map<String, Object?> map) => Fuel(
    id: map[FuelFields.id] as int?,
    name: map[FuelFields.name] as String,
    unit: map[FuelFields.unit] as String,
    plugType: map[FuelFields.plugType] as String
  );
}


const String tablePlug='plugTypes';
class PlugFields{
  static final List<String> values =[
    id, fuelId, name
  ];
  static const String id ='_id';
  static const String fuelId ='_fuelId';
  static const String name = '_name';
}

class Plug{
  final int? id;
  final int? fuelId;
  final String name;

  const Plug({
    this.id,
    required this.fuelId,
    required this.name,
  });

  Plug copy({
    int? id,
    int? fuelId,
    String? name,
  }) =>Plug(
    id: id ?? this.id,
    fuelId: fuelId ?? this.fuelId,
    name: name ?? this.name,
  );


  Map<String, Object?> toJson() =>{
    PlugFields.id: id,
    PlugFields.fuelId :fuelId,
    PlugFields.name: name,
  };
  static Plug fromJson(Map<String, Object?> map) => Plug(
    id: map[PlugFields.id] as int?,
    fuelId: map[PlugFields.fuelId] as int?,
    name: map[PlugFields.name] as String,
  );
}

