import 'package:alter_tank/models/station.dart';
import 'package:flutter/material.dart';

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
  String range ="5km";
  List<StationDetailed> stations=<StationDetailed>[];
  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Center(
              child:
              CircularProgressIndicator(),
            )
          ],
        ):Column(
          children: [
            DropdownButton<String>(
              value: range,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  range = newValue!;
                });
              },
              items: <String>['5km', '10km', '20km', '50km','100km''']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(child: buildStations()),
          ],
        )
    );
  }

  Widget buildStations() => ListView.builder(
    itemCount: stations.length,
    itemBuilder: (BuildContext context, int index){
      final station = stations[index];
      return GestureDetector(
        onTap: (){
          //carDetails(car.id);
        },
        child:
        Container(
          height: 50,
          child: Row(
            children:[
              const Icon(Icons.near_me_rounded),
              Text(
                  '${station.name}, ${station.lastPrice}'
              ),
            ],
          ),
        ),
      );
    },
  );
}