final String tableCars='cars';

class CarFields{
    static final List<String> values =[
        id, name, type, plug, mileage, capacity
    ];

    static final id ='_id';
    static const String name = '_name';
    static const String type = '_type';
    static const String plug = '_plugType';
    static const String mileage = 'mileage';
    static const String capacity = 'capacity';
}

class Car{
    final int? id;
    final String name;
    final int type;
    final int plug;
    final int mileage;
    final int capacity;

    const Car({
        this.id,
        required this.name,
        required this.type,
        required this.plug,
        required this.mileage,
        required this.capacity,
    });

    Car copy({
        int? id,
        String? name,
        int? type,
        int? plug,
        int? mileage,
        int? capacity,
    }) =>Car(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
            plug: plug ?? this.plug,
            mileage: mileage?? this.mileage,
            capacity: capacity?? this.capacity,
        );


    Map<String, Object?> toJson() =>{
        CarFields.id: id,
        CarFields.name: name,
        CarFields.type: type,
        CarFields.plug: plug,
        CarFields.mileage: mileage,
        CarFields.capacity: capacity,
    };
    static Car fromJson(Map<String, Object?> map) => Car(
        id: map[CarFields.id] as int?,
        name: map[CarFields.name] as String,
        type: map[CarFields.type] as int,
        plug: map[CarFields.plug] as int,
        mileage: map[CarFields.mileage] as int,
        capacity: map[CarFields.capacity] as int,
    );
}

