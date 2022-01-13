import 'package:alter_tank/db/db.dart';
import 'package:alter_tank/db/fuel_db.dart';
import 'package:alter_tank/db/fueling_logs.dart';
import 'package:alter_tank/models/car.dart';
import 'package:alter_tank/models/fueling_log.dart';
import 'package:alter_tank/models/geolocation.dart';
import 'package:alter_tank/models/station.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class AddFueling extends StatelessWidget {
  AddFueling(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  Widget build(BuildContext context) {
    return AddFuelLog(car);
  }
}

class AddFuelLog extends StatefulWidget {
  AddFuelLog(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  _AddFuelLogState createState() => _AddFuelLogState(car);
}

class _AddFuelLogState extends State<AddFuelLog>
    with AutomaticKeepAliveClientMixin {
  _AddFuelLogState(this.car) {
    FuelDatabase.instance.getPlug(car.plug).then((value) {
      FuelDatabase.instance
          .getFuel(value.fuelId ?? 0)
          .then((_value) => setState(() {
                unit = _value.unit;
              }));
      fuelId = value.fuelId!;
    });
    FuelingLogsDatabase.instance
        .getLast(car.id ?? 0)
        .then((value) => {if (value.isNotEmpty) fueling = value[0]});
  }

  Car car;

  bool shareCost = true;
  bool dateNow = true;
  bool fullTank = true;
  bool knowFuelLevel = false;
  bool isLoading = false;
  bool hasSaved =false;

  String unit = "";
  FuelLog? fueling;
  late int fuelId;

  DateTime date = DateTime.now();
  String pricePerUnit = "";
  String mileage = "";
  String fuel = "";

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          )
        : SingleChildScrollView(
            child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Column(children: [
                  TextFormField(
                    onSaved: (val) => setState(() {
                      mileage = val!;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wartość nie może być pusta";
                      }
                      if (car.mileage > int.parse(value)) {
                        return "Stan licznika musi być większy niż: ${car.mileage}km";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Stan licznika",
                        helperText:
                            "Stan licznika musi być większy niż ostatnio."),
                  ),
                  TextFormField(
                    onSaved: (val) => setState(() {
                      fuel = val!;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wartość nie może być pusta";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    decoration: const InputDecoration(
                      labelText: "Ilość paliwa",
                    ),
                  ),
                  TextFormField(
                    onSaved: (val) => setState(() {
                      pricePerUnit = val!;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wartość nie może być pusta";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,10}'))
                    ],
                    decoration: InputDecoration(
                      labelText: "Cena za $unit",
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: dateNow,
                        onChanged: (bool? value) {
                          setState(() {
                            dateNow = value!;
                            date = DateTime.now();
                          });
                        },
                      ),
                      const Text("Tankowanie teraz?"),
                    ],
                  ),
                  dateNow
                      ? Container()
                      : DateTimePicker(
                          validator: (value) {
                            if (dateNow) {
                              setState(() {
                                date = DateTime.now();
                              });
                              return null;
                            } else if (value == null || value.isEmpty) {
                              return "Data nie może być pusta";
                            }
                          },
                          type: DateTimePickerType.dateTime,
                          lastDate: DateTime.now(),
                          firstDate: fueling != null
                              ? fueling?.date
                              : DateTime(DateTime.now().year - 1),
                          dateLabelText: 'Data tankowania',
                          onChanged: (val) => setState(() {
                            date = DateTime.parse(val);
                          }),
                        ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: shareCost,
                        onChanged: (bool? value) {
                          setState(() {
                            shareCost = value!;
                          });
                        },
                      ),
                      const Text(
                          "Chcesz podzielić się anonimowo kosztem paliwa?"),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        formKey.currentState!.validate()
                            ? {
                                formKey.currentState!.save(),
                                acceptFueling()
                              }
                            : null;
                      },
                      child: const Text("Zapisz")),
                ]),
              ]),
            ),
          )
    );
  }

  Future acceptFueling() async {
    setState(() {
      isLoading = true;
    });
    List<StationDetailed> stations;
    LatLng center;
    shareCost
        ? await Geolocation.getLocation().then((response) async {
            center = LatLng(response.latitude, response.longitude);
            await StationDetailed.getNearbyStations(center.latitude.toString(),
                    center.longitude.toString(), "1", car.plug.toString())
                .then((result) {
              stations = result;
              if (stations.isNotEmpty) {
                _selectStation(stations, double.parse(pricePerUnit),
                    fuelId.toString(), date);
              } else {
                _info("Nie znaleziono stacji w pobliżu");
              }
              saveData();
            });
          })
        : {
          saveLocal(car.id!, fuel, mileage, date, pricePerUnit.toString(), car.mileage).then((val){
            setState(() {
              hasSaved=val;
              _info("Nie udostępnimy ceny paliwa innym użytkownikom");
            });
          })

        };
    setState(() {
      isLoading = false;
    });
  }

  saveData() async {}
  Future<void> _selectStation(List<StationDetailed> stations,
      double pricePerUnit, String fuelType, DateTime date) async {
    late String station;
    List<DropdownMenuItem<String>> _stations = <DropdownMenuItem<String>>[];
    for (var element in stations) {
      _stations.add(DropdownMenuItem(
          child: Text(element.name), value: element.id));
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wybierz właściwą stację:'),
          content: SingleChildScrollView(
            child: DropdownButtonFormField<String>(
              icon: const Icon(Icons.arrow_downward),
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Stacja tankowania",
              ),
              items: _stations,
              onChanged: (String? newValue) {
                setState(() {
                  station = newValue!;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zamknij'),
              onPressed: () {
                Navigator.of(context).pop();saveLocal(car.id!, fuel, mileage, date, pricePerUnit.toString(), car.mileage).then((val){
                  setState(() {
                    hasSaved=val;
                    _info("Nie udostępnimy ceny paliwa innym użytkownikom");
                  });
                });
              },
            ),
            TextButton(
              child: const Text('Wyślij'),
              onPressed: () {
                StationDetailed.addPrice(
                        station, fuelType, pricePerUnit.toString(), date)
                    .then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                    saveLocal(car.id!, fuel, mileage, date, pricePerUnit.toString(), car.mileage).then((val){
                      setState(() {
                        hasSaved=val;
                        _info("Dziękujemy za zaangażowanie, zapisaliśmy twoje zgłoszenie");
                      });
                    });

                  } else {
                    Navigator.of(context).pop();
                    saveLocal(car.id!, fuel, mileage, date, pricePerUnit.toString(), car.mileage).then((val){
                      setState(() {
                        hasSaved=val;
                        _info("Niestety wystąpił błąd sieci, nie zapisaliśmy danych o cenie");
                      });
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }


  Future<bool> saveLocal(int carId, String units, String mileage, DateTime date,
      String price, int carMileage) async {
    FuelLog log = FuelLog(
        carId: carId,
        units: double.parse(units),
        mileage: double.parse(mileage),
        cost: (double.parse(units) * double.parse(price)),
        date: date,
        usage: (100*double.parse(units))/(double.parse(mileage)-carMileage)
    );
    if(await FuelingLogsDatabase.instance.create(log).then((val){
      final _car = car.copy(
        id: car.id,
        name: car.name,
        type: car.type,
        plug: car.plug,
        mileage: int.parse(mileage),
        capacity: car.capacity,
      );
      setState(() {
        car=_car;
      });

      CarsDatabase.instance.updateCar(_car);
      return true;
    })) {
      return true;
    } else {
      return false;
    }

  }

  Future<void> _info(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content:  SingleChildScrollView(
            child: hasSaved?
            const Text("Zapisaliśmy dane w twoim rejestrze"):
            const Text("Nie udało się zapisać danych lokalnie"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zamknij'),
              onPressed: () async {
                Navigator.of(context).pop();
                  setState(() {
                    hasSaved=false;
                  });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
