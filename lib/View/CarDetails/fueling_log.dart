import 'package:alter_tank/db/fueling_logs.dart';
import 'package:alter_tank/models/fueling_log.dart';
import 'package:flutter/material.dart';

class FuelingLogs extends StatelessWidget {
  FuelingLogs(int index){
    this.index=index;
  }
  late int index;
  @override
  Widget build(BuildContext context) {
    return FuelingDetails(this.index);
  }
}
class FuelingDetails extends StatefulWidget {
  FuelingDetails(int index) {
    this.index=index;
  }
  late int index;
  @override
  _FuelingDetailsState createState() => _FuelingDetailsState(this.index);
}

class _FuelingDetailsState extends State<FuelingDetails> {
  late List<FuelLog> fuelingLogs;
  bool isLoading = false;
  int CarIndex=0;
  List<DropdownMenuItem<String>> timeSpan=<DropdownMenuItem<String>>[];
  String datespan="";

  @override
  void initState(){
    super.initState();
    updateLogs();
  }
  _FuelingDetailsState(int index){
    CarIndex = index;
    timeSpan.add(const DropdownMenuItem(child: Text("Ten miesiąc"),value: "0"));
    timeSpan.add(const DropdownMenuItem(child: Text("Ostatnie 30 dni"),value: "1"));
    timeSpan.add(const DropdownMenuItem(child: Text("Ostatnie 90 dni"),value: "2"));
    timeSpan.add(const DropdownMenuItem(child: Text("Ten rok"),value: "3"));
    timeSpan.add(const DropdownMenuItem(child: Text("Ostatnie 365 Dni"),value: "4"));
    timeSpan.add(const DropdownMenuItem(child: Text("Od początku"),value: "5"));
  }
  updateLogs() async{
    setState(() {
      isLoading=true;
    });
    this.fuelingLogs = await FuelingLogsDatabase.instance.getFuelingLogs(this.CarIndex, this.datespan);
    setState(() {
      isLoading=false;
    });
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child:
          CircularProgressIndicator(),
        )
      ],
    ): Column(
      children: [
        Padding(
          padding: EdgeInsets.all(7.0),
          child: DrawTopBar(),
        ),
        Padding(
          padding: EdgeInsets.all(7.0),
          child:ChangeTimeSpan(),
        ),
        Logs(),
      ],
    );
  }
  Widget ChangeTimeSpan()=>Container(
    child: DropdownButtonFormField<String>(
      icon: const Icon(Icons.arrow_downward),
      isExpanded: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Okres czasu",
      ),
      items:timeSpan,
      onChanged: ((String? newVal)=>{
        setState(()=> datespan=newVal!)
      }),
    ),
  );

  Widget DrawTopBar()=>Container(
    child: Row(
      children: const[
        Text(
            "Średnie spalanie"
        ),
        Text(
            "Koszt Paliwa"
        ),
        Text(
            "Pokonany dystans"
        ),
      ],
    ),
  );

  Widget Logs() => ListView.builder(
    itemCount: fuelingLogs.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index){
      final log = fuelingLogs[index];
      return Row(
        children:[
          Text("${log.date}"),
          Text("${log.cost}"),
          Text("${log.mileage}"),
        ],
      );
    },
  );
}

