import 'package:alter_tank/models/car.dart';
import 'package:flutter/material.dart';
import 'package:alter_tank/db/db.dart';
import 'package:alter_tank/View/NewCar/add_new_car.dart';
import 'package:alter_tank/View/CarDetails/car_main_page.dart';
class ListOfCars extends StatelessWidget{
  const ListOfCars({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AlterTank'),
        centerTitle: true,
        elevation: 7.0,
        ),
      body: ListOf(),
    );
  }
}
class ListOf extends StatefulWidget {
  const ListOf({Key? key}) : super(key: key);
  @override
  ListOfState createState() => ListOfState();
}

class ListOfState extends State<ListOf> {
  late List<Car> cars;
  bool isLoading=false;
  @override
  void initState(){
    super.initState();
    refreshCars();
  }
  @override
  void dispose(){
    CarsDatabase.instance.close();
    super.dispose();
  }
  Future refreshCars() async {
    setState(() {
      isLoading=true;
    });
    this.cars = await CarsDatabase.instance.getCars();
    setState(() {
      isLoading = false;
    });
  }
  Widget buildCars() => ListView.builder(
    itemCount: cars.length,
    itemBuilder: (BuildContext context, int index){
      final car = cars[index];
      return GestureDetector(
        onTap: (){
          carDetails(car);
        },
        child:
        Container(
          height: 50,
          child: Row(
            children:[
              Image.asset(
                'lib/assets/${car.type}.png'
              ),
              Text(
                  '${car.name}, ${car.mileage}'
              ),
            ],
          ),
        ),
      );
    },
  );
  @override
  Widget build(BuildContext context) =>Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              cars.isEmpty?
              Column(
                children: const [
                  Center(
                    child: Text('Nie posiadasz jeszcze pojazdów'),
                  )
                ],
              ):Expanded(child: buildCars()),
              ElevatedButton(
                  onPressed: newCar,
                  child: const Text("Dodaj nowy pojazd")),
            ],
          )
      );
  Future newCar() async{
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_)=>const AddNewCar()
      ),
    ).whenComplete(() => refreshCars());
  }
  Future carDetails(car) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_)=>CarDetailsPage(car)
      ),
    ).whenComplete(() => refreshCars());
  }
}


