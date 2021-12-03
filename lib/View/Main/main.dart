import 'package:flutter/material.dart';
import 'package:alter_tank/View/Main/list_of_cars.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async{
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Twoje poajzdy",
      theme:ThemeData.dark(),
      home: ListOfCars(),
    );
  }
}

