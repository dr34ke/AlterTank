import 'package:flutter/material.dart';
import 'package:alter_tank/View/CarDetails/map.dart';

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
  _State(index){
    this.index=index;
  }
  String carName="";
  late int index;
  int _selected=0;
  PageController pageController = PageController();
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
        title: Text('${carName}'),
        centerTitle: true,
        elevation: 7.0,
      ),
      body: PageView(
        controller: pageController,
        children: [
          Map(),
          Map(),
          Map(),
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
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list_rounded),
          label: 'Rejestr tankowania',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_rounded),
          label: 'Mapa',
          backgroundColor: Colors.red,
        ),
      ],
      currentIndex: _selected,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

