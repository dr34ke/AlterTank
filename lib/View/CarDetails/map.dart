import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatelessWidget {
  Map({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MapView();
  }
}
class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late Position _currentPosition;
  late String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  void initState(){
    _getCurrentLocation();
  }
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/styles/v1/dr34ke/cj6j9qb7s611s2ro5n4e3bp3n/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHIzNGtlIiwiYSI6ImNqNmo5cTV1azEyejczMXAydXJpczNrMWMifQ.tEhMoByQZiqvRFF0bH2Jcw",
            additionalOptions:{
              'access_token':'pk.eyJ1IjoiZHIzNGtlIiwiYSI6ImNqNmo5cTV1azEyejczMXAydXJpczNrMWMifQ.tEhMoByQZiqvRFF0bH2Jcw',
              'id':'mapbox.mapbox-streets-v8',
            }
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(51, 0),
                builder: (ctx) =>
                    Container(
                      child: FlutterLogo(),
                    ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

