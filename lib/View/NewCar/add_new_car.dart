import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alter_tank/db/fuel_db.dart';
import 'package:alter_tank/db/db.dart';
import 'package:alter_tank/models/car.dart';

class AddNewCar extends StatelessWidget {
  const AddNewCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewCar();
  }
}

class NewCar extends StatefulWidget {
  const NewCar({Key? key}) : super(key: key);
  @override
  _NewCarState createState() => _NewCarState();
}

class _NewCarState extends State<NewCar> {
  late String fuelType;
  var plugType;
  late String name;
  late String mileage;
  late String capacity;
  String typeName="";
  bool isPlugTypeVisible = false;
  late List<DropdownMenuItem<String>> fuelTypes=<DropdownMenuItem<String>>[];
  late List<DropdownMenuItem<String>> plugTypes=<DropdownMenuItem<String>>[];
  bool isLoading = false;


  @override
  void initState(){
    super.initState();
    refreshFuels();
  }
  Future refreshFuels() async {
    var fuels= await FuelDatabase.instance.getFuels();
    for (var element in fuels) {
      fuelTypes.add(DropdownMenuItem(child: Text("${element.name}"),value: "${element.id}"));
    }
  }
  Future refreshPlugs() async {
    var plugs= await FuelDatabase.instance.getPlugs(fuelType);
    setState(() {
      plugTypes.clear();
    });

    if(plugs.isNotEmpty) {
      setState(() {
        plugType='';
        isPlugTypeVisible =true;
        List<DropdownMenuItem<String>> newItems=<DropdownMenuItem<String>>[];
        plugs.forEach((element) {
          newItems.add(DropdownMenuItem(child: Text("${element.name}"),value: "${element.id}"));
        });
        plugTypes=newItems;
        plugType=newItems[0].value;
      });
    }
    else{
      setState(() {
        isPlugTypeVisible= false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nowy pojazd"),
      ),
      body:
      isLoading ? const CircularProgressIndicator():
      SingleChildScrollView(
        child:Padding(
          child:Column(
            children:[
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nazwa własna pojazdu',
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      name = newValue!;
                    });
                  },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Przebieg pojazdu (km)',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    mileage = newValue!;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pojemność zbiornika',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    capacity = newValue!;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                  icon: const Icon(Icons.arrow_downward),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Rodzaj paliwa",
                  ),
                  items: fuelTypes,
                  onChanged: (String? newValue) {
                    setState(() {
                      fuelType = newValue!;
                      refreshPlugs();
                    });
                  },
                ),
              const SizedBox(height: 10),
              plugTypesBuild(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async => {
                    setState(() => isLoading = true),
                    await adNewCar(),
                    setState(() => isLoading = false)
                  },
                  child: const Text(
                    "Dodaj nowy pojazd",
                  ),
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
        ),
      )
    );
  }

  Future adNewCar() async {
    Car car = Car(
      name: name,
      mileage: int.parse(mileage),
      type: int.parse(fuelType),
      plug: int.parse(plugType),
      capacity: int.parse(capacity),
    );
    await CarsDatabase.instance.create(car);
    Navigator.pop(context, true);
  }

  Widget plugTypesBuild(){
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.arrow_downward),
      isExpanded: true,
      value: plugType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: typeName,
      ),
      items: plugTypes,
      onChanged: (String? newValue) {
        setState(() {
          plugType = newValue!;
        });
      },
    );
  }
}



