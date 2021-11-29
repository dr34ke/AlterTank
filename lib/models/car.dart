final String tableCars='cars';

class CarFields{
    static final List<String> values =[
        id, name, type, plug, mileage
    ];

    static final String id ='_id';
    static final String name = '_name';
    static final String type = '_type';
    static final String plug = '_plugType';
    static final String mileage = 'mileage';
}

class Car{
    final int? id;
    final String name;
    final int type;
    final int plug;
    final int mileage;

    const Car({
        this.id,
        required this.name,
        required this.type,
        required this.plug,
        required this.mileage,
    });

    Car copy({
        int? id,
        String? name,
        int? type,
        int? plug,
        int? mileage,
    }) =>Car(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
            plug: plug ?? this.plug,
            mileage: mileage?? this.mileage,
        );


    Map<String, Object?> toJson() =>{
        CarFields.id: id,
        CarFields.name: name,
        CarFields.type: type,
        CarFields.plug: plug,
        CarFields.mileage: mileage,
    };
    static Car fromJson(Map<String, Object?> map) => Car(
        id: map[CarFields.id] as int?,
        name: map[CarFields.name] as String,
        type: map[CarFields.type] as int,
        plug: map[CarFields.plug] as int,
        mileage: map[CarFields.mileage] as int,
    );
}

