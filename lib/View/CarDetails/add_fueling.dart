import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';


class AddFueling extends StatelessWidget {
  AddFueling(this.index);
  late int index;
  @override
  Widget build(BuildContext context) {
    return AddFuelLog(index);
  }
}
class AddFuelLog extends StatefulWidget {
  AddFuelLog(this.index, {Key? key});
  late int index;
  @override
  _AddFuelLogState createState() => _AddFuelLogState();
}

class _AddFuelLogState extends State<AddFuelLog> {
  bool shareCost=true;
  bool dateNow=true;
  bool fullTank=true;
  bool knowFuelLevel=false;
  String unit="kw";
  String tankStation="One";
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(7.0),
            child:
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Licznik (km)",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ilość paliwa",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Cena/${unit}",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Koszt",
              ),
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
            padding: EdgeInsets.only(left: 10.0, top:0.0, right: 10.0, bottom: 3.0),
            child:DateTimePicker(
              type: DateTimePickerType.dateTime,
              lastDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year-2),
              dateLabelText: 'Data tankowania',
              onChanged: (val) => print(val),
              validator: (val) {
                return null;
              },
              onSaved: (val) => print(val),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(7.0),
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
                padding: EdgeInsets.all(7.0),
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
          knowFuelLevel?Container(
            child:Padding(
              padding: EdgeInsets.all(7.0),
              child:TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Licznik (km)",
                ),
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
            padding: EdgeInsets.only(left: 10.0, top:0.0, right: 10.0, bottom: 3.0),
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
            padding: EdgeInsets.only(left: 14.0, top:0.0, right: 14.0, bottom: 3.0),
            child:ElevatedButton(
                onPressed:()=>{},
                child: const Text("Zapisz tankowanie")
            ),
          ),
        ]
    );
  }
}
