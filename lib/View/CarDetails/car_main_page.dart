import 'package:alter_tank/View/CarDetails/fueling_log.dart';
import 'package:alter_tank/models/car.dart';
import 'package:flutter/material.dart';
import 'package:alter_tank/View/CarDetails/map.dart';

import 'add_fueling.dart';
import 'nearby_stations.dart';


class CarDetailsPage extends StatelessWidget {
  CarDetailsPage(Car _car, {Key? key}) : super(key: key){
    car=_car;
  }
  late Car car;
  @override
  Widget build(BuildContext context) {
    return carDetails(car);
  }
}
class carDetails extends StatefulWidget {
  carDetails(Car _car, {Key? key}) : super(key: key){
    car=_car;
  }
  late Car car;
  @override
  _State createState() => _State(car);
}

class _State extends State<carDetails> {
  final pageStorageBucket = PageStorageBucket();

  @override
  void initState(){
    super.initState();
  }
  _State(this.car);
  Car car;
  int _selected=0;
  PageController pageController = PageController(
    keepPage: true
  );

  void _onItemTapped(int index) {
    setState(() {
      _selected = index;
      pageController.jumpToPage(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: Text(car.name),
        centerTitle: true,
        elevation: 7.0,
      ),
      body: PageView(
        controller: pageController,
        children: [

          AddFueling(car),
          FuelingLogs(car),
          Map(car),
          NearbyStations(car),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
  Widget mainBody(){
    return Container(
      color: const Color.fromARGB(255, 130, 130, 130),
    );
  }
  Widget bottomBar(){
    return BottomNavigationBar(
      items:const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_turned_in_rounded),
          label: 'Tankowanie',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Rejestr tankowania',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_rounded),
          label: 'Mapa',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list_rounded),
          label: 'Stacje w pobliżu',
          backgroundColor: Colors.black,
        ),
      ],
      currentIndex: _selected,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

