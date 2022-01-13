import 'package:alter_tank/db/fuel_db.dart';
import 'package:alter_tank/db/fueling_logs.dart';
import 'package:alter_tank/models/car.dart';
import 'package:alter_tank/models/fueling_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FuelingLogs extends StatelessWidget {
  FuelingLogs(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  Widget build(BuildContext context) {
    return FuelingDetails(car);
  }
}

class FuelingDetails extends StatefulWidget {
  FuelingDetails(this.car, {Key? key}) : super(key: key);
  Car car;
  @override
  _FuelingDetailsState createState() => _FuelingDetailsState(car);
}

class _FuelingDetailsState extends State<FuelingDetails> {
  _FuelingDetailsState(this.car);

  Car car;

  late List<FuelLog> fuelingLogs;
  late List<FuelLog> thisMonthLogs;
  late List<FuelLog> lastMonthLogs;
  late List<FuelLog> thisYearLogs;
  late List<FuelLog> lastYearLogs;

  bool isLoading = false;
  String unit = "";
  String fuelId = "";

  @override
  void initState() {
    FuelDatabase.instance.getPlug(car.plug).then((value) {
      FuelDatabase.instance
          .getFuel(value.fuelId ?? 0)
          .then((_value) => setState(() {
                unit = _value.unit;
              }));
      fuelId = value.fuelId.toString();
    });

    super.initState();
    updateLogs();
  }

  updateLogs() async {
    setState(() {
      isLoading = true;
    });
    fuelingLogs = await FuelingLogsDatabase.instance.getFuelingLogs(car.id!);

    thisMonthLogs =
        fuelingLogs.where((i) => i.date.month == DateTime.now().month).toList();
    lastMonthLogs = fuelingLogs
        .where((i) => i.date.month == DateTime.now().month - 1)
        .toList();

    thisYearLogs =
        fuelingLogs.where((i) => i.date.year == DateTime.now().year).toList();
    lastYearLogs = fuelingLogs
        .where((i) => i.date.year == DateTime.now().year - 1)
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            child: Column(
              children: [
                fueling(),
                fuel(),
                usage(),
                logs(),
              ],
            ),
          );
  }

  Widget logs() => ListView.builder(
        itemCount: fuelingLogs.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final log = fuelingLogs[index];
          return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                                '${log.usage.toStringAsFixed(2)} ${unit}/100km'),
                          ),
                          Container(
                              child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                              ),
                              Text("${log.date.hour}:${log.date.minute}"),
                              const Icon(
                                Icons.calendar_today,
                              ),
                              Text(
                                  "${log.date.day}-${log.date.month}-${log.date.year}"),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.drive_eta_outlined,
                              ),
                              Text("${log.mileage} km"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money_outlined,
                              ),
                              Text("${log.cost.toStringAsFixed(2)} zł"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_gas_station_outlined,
                              ),
                              Text("${log.units} ${unit}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),
              ));
        },
      );

  Widget fueling() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_gas_station_outlined,
                          ),
                          Text(
                            'Tankowania: ${fuelingLogs.length}',
                            textScaleFactor: 1.6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W tym roku:',
                            ),
                            Text(
                              '${thisYearLogs.length}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W tym miesiącu:',
                            ),
                            Text(
                              '${thisMonthLogs.length}',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W poprzednim roku:',
                            ),
                            Text(
                              '${lastYearLogs.length}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('W poprzednim miesiącu:'),
                            Text(
                              '${lastMonthLogs.length}',
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              /*Container(
                  margin: const EdgeInsets.all(5.0),
                  child:,
                ),*/
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[700],
          ),
        ));
  }

  Widget fuel() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                          ),
                          Text(
                            'Ilość paliwa: ${fuelingLogs.fold(0.0, (double acc, FuelLog cur) => acc + cur.units)} ${unit}',
                            textScaleFactor: 1.6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W tym roku:',
                            ),
                            Text(
                              '${thisYearLogs.fold(0.0, (double acc, FuelLog cur) => acc + cur.units)} ${unit}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W tym miesiącu:',
                            ),
                            Text(
                              '${thisMonthLogs.fold(0.0, (double acc, FuelLog cur) => acc + cur.units)} ${unit}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W poprzednim roku:',
                            ),
                            Text(
                              '${lastYearLogs.fold(0.0, (double acc, FuelLog cur) => acc + cur.units)} ${unit}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'W poprzednim miesiącu:',
                            ),
                            Text(
                              '${lastMonthLogs.fold(0.0, (double acc, FuelLog cur) => acc + cur.units)} ${unit}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[700],
          ),
        ));
  }

  Widget usage() {
    double min = 1000000000;
    double max = 0;
    for (var i = 0; i < fuelingLogs.length; i++) {
      // Checking for largest value in the list
      if (fuelingLogs[i].mileage > max) {
        max = fuelingLogs[i].mileage;
      }
      // Checking for smallest value in the list
      if (fuelingLogs[i].mileage < min) {
        min = fuelingLogs[i].mileage;
      }
    }
    double minUsage = 1000000000;
    double maxUsage = 0;
    for (var i = 0; i < fuelingLogs.length; i++) {
      // Checking for largest value in the list
      if (fuelingLogs[i].usage > maxUsage) {
        maxUsage = fuelingLogs[i].usage;
      }
      // Checking for smallest value in the list
      if (fuelingLogs[i].usage < minUsage) {
        minUsage = fuelingLogs[i].usage;
      }
    }
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                          ),
                          fuelingLogs.length>1?Text(
                            'Zużycie paliwa: ${((fuelingLogs.fold(0.0, (double p, FuelLog c) => p + c.units)-fuelingLogs.last.units) *100/ (max - min)).toStringAsFixed(2)} ${unit}/100km',
                            textScaleFactor: 1.6,
                          ):const Text(
                            'Zużycie paliwa: bd',
                            textScaleFactor: 1.6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Najniższe:',
                            ),
                            Text(
                              '${minUsage.toStringAsFixed(2)} ${unit}/100km',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Najwyższe:',
                            ),
                            Text(
                              '${maxUsage.toStringAsFixed(2)} ${unit}/100km',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[700],
          ),
        ));
  }
}
