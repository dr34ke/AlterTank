import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapController controller = MapController();
  LatLng? vehicle;
  @override
  void initState(){
    super.initState();
    buildMap();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FlutterMap(
        mapController: controller,
        options:new MapOptions(
          center:vehicle,
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: env['Map_Box_Api_Key'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: vehicle,
                builder: (ctx) =>
                    Container(
                      child: Icon(Icons.directions_car_rounded),
                    ),
              ),
            ],
          ),
        ],
      )
    );
  }

  getPermisions() async{
    bool perm=await Geolocator.isLocationServiceEnabled();
    if(!perm)
      await Geolocator.checkPermission();
    else return perm;
  }

  getLocation() async{
    Position? cords;
    await getPermisions().then((result)async{
      if(result){
        cords = await Geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true);
      }
    });
    return cords ?? Position();
  }
  buildMap(){
    getLocation().then((response){
      setState(() {
        vehicle=LatLng(response.latitude, response.longitude);
      });
      controller.move(vehicle, 13);
    });
  }
}

