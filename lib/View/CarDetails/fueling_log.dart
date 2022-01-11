import 'package:alter_tank/db/fueling_logs.dart';
import 'package:alter_tank/models/fueling_log.dart';
import 'package:flutter/material.dart';

class FuelingLogs extends StatelessWidget {
  FuelingLogs(this.index, {Key? key}) : super(key: key);
  int index;
  @override
  Widget build(BuildContext context) {
    return FuelingDetails(index);
  }
}
class FuelingDetails extends StatefulWidget {
  FuelingDetails(this.index, {Key? key}) : super(key: key);
  int index;
  @override
  _FuelingDetailsState createState() => _FuelingDetailsState(index);
}

class _FuelingDetailsState extends State<FuelingDetails> with AutomaticKeepAliveClientMixin{
  PageController pageController = PageController(
      keepPage: true
  );

  late List<FuelLog> fuelingLogs;
  bool isLoading = false;
  int CarIndex=0;

  @override
  void initState(){
    super.initState();
    updateLogs();
  }
  _FuelingDetailsState(int index){
    CarIndex = index;
  }
  updateLogs() async{
    setState(() {
      isLoading=true;
    });
    this.fuelingLogs = await FuelingLogsDatabase.instance.getFuelingLogs(this.CarIndex);
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
      children: const [
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
        logs(),
      ],
    );
  }

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

  Widget logs() => ListView.builder(
    itemCount: fuelingLogs.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index){
      final log = fuelingLogs[index];
      return Row(
        children:[
          Text("${log.date}"),
          Text(log.cost),
          Text(log.mileage),
        ],
      );
    },
  );

  @override
  bool get wantKeepAlive => true;
}

