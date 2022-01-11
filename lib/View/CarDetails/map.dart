import 'dart:async';
import 'package:alter_tank/models/car.dart';
import 'package:alter_tank/models/geolocation.dart';
import 'package:alter_tank/models/station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong/latlong.dart' as lt;
import 'package:map_controller/map_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatelessWidget {
  Map(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  Widget build(BuildContext context) {
    return MapView(car);
  }
}

class MapView extends StatefulWidget {
  MapView(this.car, {Key? key}) : super(key: key);
  Car car;

  @override
  State createState() => _MapViewState(car);
}

class _MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin {
  _MapViewState(this.car);
  Car car;

  MapController controller = MapController();
  late StatefulMapController statefulMapController;
  late StreamSubscription<StatefulMapControllerStateChange> sub;

  lt.LatLng vehicle = lt.LatLng(50, 20);
  List<Marker> markers = <Marker>[];
  List<StationDetailed> stations = <StationDetailed>[];

  @override
  void initState() {
    buildMap();
    statefulMapController = StatefulMapController(mapController: controller);
    sub = statefulMapController.changeFeed.listen((event) {});
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: controller,
          options: MapOptions(
            center: vehicle,
            zoom: 12.0,
            maxZoom: 17,
            minZoom: 6,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: env['Map_Box_Api_Key'],
            ),
            MarkerLayerOptions(markers: markers),
          ],
        ),
        Positioned(
            right: 10.0,
            top: 10.0,
            child: ElevatedButton(
              onPressed: () async {
                await getVisiblePoints();
              },
              child: const Icon(
                Icons.refresh_rounded,
                size: 35,
              ),
            )
        ),
      ]
    );
  }


  buildMap() async {
    await Geolocation.getLocation().then((response) {
      setState(() {
        vehicle = lt.LatLng(response.latitude, response.longitude);
        controller.move(vehicle, 12);
      });
      getVisiblePoints();
    });
  }

  getVisiblePoints() async {
    double distance = Geolocation.getDistance(
      controller.bounds.southEast.latitude,
      controller.bounds.southEast.longitude,
      controller.center.latitude,
      controller.center.longitude,
    );

    await StationDetailed.getNearbyStations(
            controller.center.latitude.toString(),
            controller.center.longitude.toString(),
            distance.toString(),
            car.plug.toString())
        .then((value) => {stations = value});

    markers.clear();
    setState(() {
      markers.add(Marker(
        width: 35.0,
        height: 35.0,
        point: vehicle,
        builder: (ctx) => const Icon(
          Icons.directions_car_rounded,
          size: 35,
        ),
      ));
      stations.forEach((element) {
        markers.add(
          Marker(
            width: 35.0,
            height: 35.0,
            point: lt.LatLng(element.latitude, element.longitude),
            builder: (ctx) => IconButton(
              icon: const Icon(
                Icons.location_on_outlined,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  _showMyDialog(element);
                });
              },
            ),
          ),
        );
      });
    });
  }


  Future<void> _showMyDialog(station) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${station.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${station.city}",
                          style: const TextStyle( fontSize: 12),
                        ),
                        station.street != null ? Text(
                          " ul. ${station.street} ${station.address}",
                          style: const TextStyle( fontSize: 12),
                        ): Text(
                          " ${station.address}",
                          style: const TextStyle( fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        station.description != null ?
                        Text(
                            "${station.description}"
                        ):const Text(
                            ""
                        )
                      ],
                    ),
                    Row(
                      children: [
                        station.lastPrice != null ?
                        Text("${station.lastPrice}"):
                        const Text("Brak danych o cenie")
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zamknij'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Nawiguj'),
              onPressed: () {
                Navigator.of(context).pop();
                launch("https://www.google.com/maps/search/?api=1&query=${station.latitude},${station.longitude}");
              },
            ),
          ],
        );
      },
    );
  }


  @override
  bool get wantKeepAlive => true;

}

