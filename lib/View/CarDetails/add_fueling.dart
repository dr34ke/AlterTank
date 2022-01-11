import 'package:alter_tank/db/fuel_db.dart';
import 'package:alter_tank/db/fueling_logs.dart';
import 'package:alter_tank/models/car.dart';
import 'package:alter_tank/models/fueling_log.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';


class AddFueling extends StatelessWidget {
  AddFueling(this.car);
  Car car;
  @override
  Widget build(BuildContext context) {
    return AddFuelLog(car);
  }
}
class AddFuelLog extends StatefulWidget {
  AddFuelLog(this.car, {Key? key});
  Car car;
  @override
  _AddFuelLogState createState() => _AddFuelLogState(car);
}

class _AddFuelLogState extends State<AddFuelLog> with AutomaticKeepAliveClientMixin{
  _AddFuelLogState(this.car);
  Car car;

  bool shareCost=true;
  bool dateNow=true;
  bool fullTank=true;
  bool knowFuelLevel=false;

  String? unit;
  FuelLog? fueling;
  String tankStation="One";

  String? date;
  String? pricePerUnit;
  String? mileage;
  String? fuel;

  @override
  void initState(){
    FuelDatabase.instance.getPlug(car.plug).then((value) =>
        FuelDatabase.instance.getFuel(value.fuelId??0).then((_value) =>
            setState(() {
              unit=_value.unit;
            })
        )
    );
    FuelingLogsDatabase.instance.getLast(car.id??0).then((value) =>
    {
      if(value.isNotEmpty)
        fueling=value[0]
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(7.0),
            child:
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Licznik (km)",
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
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child:TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ilość paliwa",
              ),
              onChanged: (String? newValue) {
                setState(() {
                  fuel = newValue!;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child:TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Cena/${unit}",
              ),
              onChanged: (String? newValue) {
                setState(() {
                  pricePerUnit = newValue!;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),

          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(7.0),
                child:Checkbox(
                  checkColor: Colors.white,
                  value: dateNow,
                  onChanged: (bool? value) {
                    setState(() {
                      dateNow = value!;
                    });
                  },
                ),
              ),
              const Text("Tankowanie teraz?"),
            ],
          ),
          dateNow? Container():Padding(
            padding: const EdgeInsets.only(left: 10.0, top:0.0, right: 10.0, bottom: 3.0),
            child:DateTimePicker(
              type: DateTimePickerType.dateTime,
              lastDate: DateTime.now(),
              firstDate: fueling != null? fueling?.date: DateTime(DateTime.now().year-1),
              dateLabelText: 'Data tankowania',
              onSaved: (val) => date=val,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child:Checkbox(
                  checkColor: Colors.white,
                  value: fullTank,
                  onChanged: (bool? value) {
                    setState(() {
                      fullTank = value!;
                      knowFuelLevel=false;
                    });
                  },
                ),
              ),
              const Text("Tankowanie do pełna?"),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child:Checkbox(
                  checkColor: Colors.white,
                  value: knowFuelLevel,
                  onChanged: fullTank? null : (bool? value) {
                    setState(() {
                      knowFuelLevel = value!;
                    });
                  },
                ),
              ),
              Text(
                "Znasz poziom paliwa w samochodzie?",
                style: fullTank? const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ):const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),

              ),
            ],
          ),
          knowFuelLevel? const Padding(
              padding: EdgeInsets.all(7.0),
              child:TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ilość w zbiorniku",
                ),
              ),
            ):Container(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(7.0),
                child:Checkbox(
                  checkColor: Colors.white,
                  value: shareCost,
                  onChanged: (bool? value) {
                    setState(() {
                      shareCost = value!;
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(7.0),
                child: Text("Chcesz podzielić się anonimowo kosztem paliwa?"),
              ),
            ],
          ),
          shareCost? Padding(
            padding: const EdgeInsets.only(left: 10.0, top:0.0, right: 10.0, bottom: 3.0),
            child:DropdownButton<String>(
              value: tankStation,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  tankStation = newValue!;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.only(left: 14.0, top:0.0, right: 14.0, bottom: 3.0),
            child:ElevatedButton(
                onPressed:()=>{},
                child: const Text("Zapisz tankowanie")
            ),
          ),
        ]
    );
  }


  //dodaj walidację licznika
  Future insertDb() async{

  }


  @override
  bool get wantKeepAlive => true;
}
