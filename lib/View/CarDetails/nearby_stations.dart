import 'package:alter_tank/models/station.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyStations extends StatelessWidget {
  NearbyStations(this.index, {Key? key}) : super(key: key);
  late int index;
  @override
  Widget build(BuildContext context) {
    return SearchForNearbyStations(index);
  }
}

class SearchForNearbyStations extends StatefulWidget {
  SearchForNearbyStations(this.index, {Key? key}) : super(key: key);
  late int index;
  @override
  _NearbyStations createState() => _NearbyStations();
}

class _NearbyStations extends State<SearchForNearbyStations> {
  bool isLoading = false;
  String range = "5km";
  List<StationDetailed> stations = <StationDetailed>[];
  @override
  void initState() {
    super.initState();
    setState(() {
      StationDetailed.getNearbyStations().then((result) {
        this.stations = result;
      });
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
                                    child: new Container(
                                      padding: new EdgeInsets.only(right: 13.0),
                                      child: new Text(
                                        "${station.name}",
                                        overflow: TextOverflow.ellipsis,
                                        style: new TextStyle(
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
                                "${station.city} ul. ${station.street} ${station.address}",
                                style: TextStyle( fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("${station.description}")
                            ],
                          ),
                          Row(
                            children: [
                              Text("${station.lastPrice}")
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
}

/*


 */
