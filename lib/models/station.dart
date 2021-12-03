import 'dart:convert';

import 'package:http/http.dart' as http;

final String tableFuelLogs='favoriteStations';
class StationsFields{
  static final List<String> values =[
    id, latitude, longitude, name
  ];
  static final String id ='_id';
  static final String latitude = '_latitude';
  static final String longitude = '_longitude';
  static final String name = '_name';
}

class Station{
  final int? id;
  final String latitude;
  final String longitude;
  final String name;

  const Station({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Station copy({
    int? id,
    String? latitude,
    String? longitude,
    String? name,
  }) =>Station(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    name: name ?? this.name,
  );


  Map<String, Object?> toJson() =>{
    StationsFields.id: id,
    StationsFields.latitude: latitude,
    StationsFields.longitude: longitude,
    StationsFields.name: name,
  };

  static Station fromJson(Map<String, Object?> map) => Station(
    id: map[StationsFields.id] as int?,
    latitude: map[StationsFields.longitude] as String,
    longitude: map[StationsFields.longitude] as String,
    name: map[StationsFields.name] as String,
  );
}



class StationsDetailsFields{
  static final List<String> values =[
    id, latitude, longitude, name, lastPrice, description
  ];
  static final String id ='_id';
  static final String latitude = '_latitude';
  static final String longitude = '_longitude';
  static final String name = '_name';
  static final String lastPrice = '_lastPrice';
  static final String description = '_description';
}
class StationDetailed extends Station{
  final String lastPrice;
  final String description;

  const StationDetailed({
    id,
    latitude,
    longitude,
    name,
    required this.lastPrice,
    required this.description,
  }): super(id: id, latitude: latitude, longitude: longitude, name: name);

  StationDetailed copy({
    int? id,
    String? latitude,
    String? longitude,
    String? name,
    String? lastPrice,
    String? description,
  }) =>StationDetailed(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    name: name ?? this.name,
    lastPrice: lastPrice ?? this.lastPrice,
    description: description ?? this.description,
  );


  static StationDetailed fromJson(Map<String, Object?> map) => StationDetailed(
    id: map[StationsDetailsFields.id] as int?,
    latitude: map[StationsDetailsFields.longitude] as String,
    longitude: map[StationsDetailsFields.longitude] as String,
    name: map[StationsDetailsFields.name] as String,
    lastPrice: map[StationsDetailsFields.lastPrice] as String,
    description: map[StationsDetailsFields.description] as String,
  );

  Future<List<StationDetailed>> getNearbyStations(String latitude, String longitude, String range) async{
    final response= await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<StationDetailed> stations = List<StationDetailed>.from(l.map((model)=> StationDetailed.fromJson(model)));
      return stations;
    } else {
      throw Exception('Failed to load album');
    }
  }
}



