import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class StationDetailed {
  String? id;
  double? latitude;
  double? longitude;
  String? name;
  String? lastPrice;
  String? description;
  String? street;
  String? address;
  String? city;

  StationDetailed(this.id, this.name, this.latitude, this.longitude, this.lastPrice, this.description, this.address,this.city,this.street);

  factory StationDetailed.fromJson(dynamic json) {
    return StationDetailed(json['id'] as String, json['name'] as String, json["latitude"] as double, json["longitude"] as double, json["lastPrice"] as String, json["description"] as String,json["address"] as String,json["city"] as String, json["street"] as String);
  }

  @override
  String toString() {
    return '{ $name }';
  }

  static Future<List<StationDetailed>> getNearbyStations(/*String latitude, String longitude, String */) async{
    final queryParameters = {
      'latitude': '49,987558',
      'longitude': '20,0461097',
      'range': '10',
      'plugType':'2',
    };
    final uri= Uri.https("localhost:44334", "/Stations/GetInRange", queryParameters);
    final response= await http.get(uri);

    if (response.statusCode == 200) {

      Iterable l = json.decode(response.body);
      List<StationDetailed> stations = List<StationDetailed>.from(l.map((model)=> StationDetailed.fromJson(model)));

      //List<StationDetailed> stations =(json.decode(response.body) as List).map((i) => StationDetailed.fromJson(i)).toList();
      //List<StationDetailed> stations = StationDetailed.fromJson(jsonDecode(response.body));
      debugPrint(stations.toString());
      return stations;
    } else {
      throw Exception('Niepowodzenie w trakcie łączenia z serwerem');
    }
  }
}

