import 'package:alter_tank/models/car.dart';
import 'package:alter_tank/models/geolocation.dart';
import 'package:alter_tank/models/station.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong/latlong.dart' as lt;

class NearbyStations extends StatelessWidget {
  NearbyStations(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  Widget build(BuildContext context) {
    return SearchForNearbyStations(car);
  }
}

class SearchForNearbyStations extends StatefulWidget {
  SearchForNearbyStations(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  _NearbyStations createState() => _NearbyStations(car);
}

class _NearbyStations extends State<SearchForNearbyStations> with AutomaticKeepAliveClientMixin{
  _NearbyStations(this.car);
  Car car;
  late lt.LatLng center;
  late bool isLoading;
  String range = "5km";
  List<StationDetailed> stations = <StationDetailed>[];
  @override
  void initState() {
    getStations();
    super.initState();
  }

  getStations() async {
    setState(() {
      isLoading = true;
    });
    await Geolocation.getLocation().then((response) {
        setState(() {
          center = lt.LatLng(response.latitude, response.longitude);
        });
      });
    await StationDetailed.getNearbyStations(
    center.latitude.toString(),
    center.longitude.toString(),
    range.replaceAll("km", ""),
    car.plug.toString()
    ).then((result) {
      stations = result;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              )
            : Column(children: [
                DropdownButton<String>(
                  value: range,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      range = newValue!;
                      getStations();
                    });
                  },
                  items: <String>['5km', '10km', '20km', '50km', '100km' '']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(child: buildStations())
              ]));
  }




  Widget buildStations() => ListView.builder(
        itemCount: stations.length,
        itemBuilder: (BuildContext context, int index) {
          final station = stations[index];
          return GestureDetector(

            onTap: () async => {
              if (await canLaunch("https://www.google.com/maps/search/?api=1&query=${station.latitude},${station.longitude}"))
              {
                await launch("https://www.google.com/maps/search/?api=1&query=${station.latitude},${station.longitude}")
              }
              else {
                throw "Could not open the map."
              }
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        size: 40,
                      ),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        "${station.name}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                  ),
                              ),
                            ],
                          ),
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
                              Text("${station.lastPrice} zł"):
                              const Text("Brak danych o cenie")
                            ],
                          )
                        ],
                      ),)
                    ],
                  ),
                ],
              ),
            );
        },
      );

  @override
  bool get wantKeepAlive => true;
}

/*


 */
