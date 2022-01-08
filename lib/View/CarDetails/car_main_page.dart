import 'package:alter_tank/View/CarDetails/fueling_log.dart';
import 'package:alter_tank/db/db.dart';
import 'package:alter_tank/models/car.dart';
import 'package:flutter/material.dart';
import 'package:alter_tank/View/CarDetails/map.dart';

import 'add_fueling.dart';
import 'nearby_stations.dart';


class CarDetailsPage extends StatelessWidget {
  CarDetailsPage(int index){
    this.index=index;
  }
  late int index;
  @override
  Widget build(BuildContext context) {
    return carDetails(index);
  }
}
class carDetails extends StatefulWidget {
  carDetails(int index){
    this.index=index;
  }
  late int index;
  @override
  _State createState() => _State(index);
}

class _State extends State<carDetails> {
  @override
  void initState(){
    super.initState();
    getCarDetails();
  }
  Future getCarDetails() async{
    car=await CarsDatabase.instance.getCar(this.index);
    setState(() {});
  }
  _State(index){
    this.index=index;
  }
  Car? car;
  late int index;
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
    return Scaffold(
      appBar:AppBar(
        title: Text('${car?.name ?? ""}'),
        centerTitle: true,
        elevation: 7.0,
      ),
      body: PageView(
        controller: pageController,
        children: [
          AddFueling(this.index),
          FuelingLogs(this.index),
          Map(),
          NearbyStations(this.index),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
  Widget mainBody(){
    return Container(
      color: Color.fromARGB(255, 130, 130, 130),
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

