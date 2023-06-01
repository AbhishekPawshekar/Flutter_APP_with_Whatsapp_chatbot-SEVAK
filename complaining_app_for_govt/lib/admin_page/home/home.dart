//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/admin_page/home/see_deptwise_details.dart';
import 'package:complaining_app_for_govt/admin_page/home/view_complaint_details_admin.dart';
import 'package:complaining_app_for_govt/all_screen_transition.dart';
import 'package:complaining_app_for_govt/login_and_registration_dart_file/login_page.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class home_admin extends StatefulWidget {
  const home_admin({Key key}) : super(key: key);

  @override
  _home_adminState createState() => _home_adminState();
}

class _home_adminState extends State<home_admin> {
  //display data in form of card
  Widget card_display_complaint_record(AsyncSnapshot dataFormFirestore ,int index){
    return Column(
        children: <Widget>[
          Text("${dataFormFirestore.data[index]['dept']}",style: TextStyle(color: Colors.red,fontSize: 14,),),
          Container(color: Colors.orange,height: 2,),
          Padding(padding: EdgeInsets.only(top: 10,left: 10,right: 10),
          child: Align(alignment: Alignment.topLeft,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/8,
                height: MediaQuery.of(context).size.height/15,
                child:CircleAvatar(backgroundImage: AssetImage('assets/vector_profile_pic.jpg',),radius: MediaQuery.of(context).size.width/10+100),
              ),
              Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.amber, // Set border color
                          width: 1.0),   // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                      boxShadow: [BoxShadow(blurRadius: 10,color: Colors.orangeAccent,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child: Row(
                    children: <Widget>[
                      Text('Name : ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                      Text('${dataFormFirestore.data[index]['name']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),),
                    ],),
                ),
                Row(
                  children: <Widget>[
                    Text('Mobile No : ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                    Text('${dataFormFirestore.data[index]['mobile_no']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),),
                  ],),
              ],),
            ],),
          ),),
          Padding(padding: EdgeInsets.only(left: 10,top: 10),
          child:Align(
            child:Column(
              children:<Widget> [
                Row(
                  children: <Widget>[
                    Text('Problem : ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                    Expanded(child: Text('${dataFormFirestore.data[index]['problem']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),maxLines: 5,overflow: TextOverflow.ellipsis,),),
                  ],),
                Row(
                  children: <Widget>[
                    Text('Location : ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                    Expanded(child: Text('${dataFormFirestore.data[index]['location']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),maxLines: 5,overflow: TextOverflow.ellipsis,),),
                  ],),

              ],
            ),
          ),
          ),
      ]);
  }
  //retrive data
  int length;
  String total_count,solved_count,unsolved_count,other_total,other_solved,other_unsolved,road_total,road_solved,road_unsolved,electric_total,electric_solved,electric_unsolved,
      bus_total,bus_solved,bus_unsolved,health_total,health_solved,health_unsolved,sewage_total,sewage_solved,sewage_unsolved;

  List<charts.Series<BarTask,String>> bardata=[];
  _generatedata(){
    var totaldata=[new BarTask('Road',double.parse(road_total)),new BarTask('Electric',double.parse(electric_total)),new BarTask('Bus',double.parse(bus_total)),new BarTask('Health',double.parse(health_total)),new BarTask('Sewage',double.parse(sewage_total)),new BarTask('Other',double.parse(other_total)),];
    var solveddata=[new BarTask('Road',double.parse(road_solved)),new BarTask('Electric',double.parse(electric_solved)),new BarTask('Bus',double.parse(bus_solved)),new BarTask('Health',double.parse(health_solved)),new BarTask('Sewage',double.parse(sewage_solved)),new BarTask('Other',double.parse(other_solved)),];
    var unsolveddata=[new BarTask('Road',double.parse(road_unsolved)),new BarTask('Electric',double.parse(electric_unsolved)),new BarTask('Bus',double.parse(bus_unsolved)),new BarTask('Health',double.parse(health_unsolved)),new BarTask('Sewage',double.parse(sewage_unsolved)),new BarTask('Other',double.parse(other_unsolved)),];

    bardata.add(
      charts.Series(
        domainFn: (BarTask bartask,_)=>bartask.task,
        measureFn:(BarTask bartask,_)=>bartask.value,
        data: totaldata,
        fillColorFn: (BarTask bartask,_)=>charts.ColorUtil.fromDartColor(Colors.blueAccent),
        fillPatternFn: (_,__)=>charts.FillPatternType.solid,
      ),
    );
    bardata.add(
      charts.Series(
        domainFn: (BarTask bartask,_)=>bartask.task,
        measureFn:(BarTask bartask,_)=>bartask.value,
        data: solveddata,
        fillColorFn: (BarTask bartask,_)=>charts.ColorUtil.fromDartColor(Colors.green),
        fillPatternFn: (_,__)=>charts.FillPatternType.solid,
      ),
    );
    bardata.add(
      charts.Series(
        domainFn: (BarTask bartask,_)=>bartask.task,
        measureFn:(BarTask bartask,_)=>bartask.value,
        data: unsolveddata,
        fillColorFn: (BarTask bartask,_)=>charts.ColorUtil.fromDartColor(Colors.red),
        fillPatternFn: (_,__)=>charts.FillPatternType.solid,
      ),
    );
    return bardata;
  }
  get_data_form_firestore_admin()async{
    List data=[];
    await firestore.collection('total_request').where('area',isEqualTo:current_email).get().then((value){
      value.docs.forEach((element) {
        data.add(element.data());
      });
      length=value.docs.length;
    }).whenComplete(()async {
      await firestore.collection("count").doc(current_email).get().then((value) {
        if(value.exists){
          total_count=value.data()['total_request'];
          solved_count=value.data()['solved_request'];
          unsolved_count=value.data()['unsolved_request'];
          other_total=value.data()['other_total'];
          other_solved=value.data()['other_solved'];
          other_unsolved=value.data()['other_unsolved'];
          road_total=value.data()['road_total'];
          road_solved=value.data()['road_solved'];
          road_unsolved=value.data()['road_unsolved'];
          electric_total=value.data()['electric_total'];
          electric_solved=value.data()['electric_solved'];
          electric_unsolved=value.data()['electric_unsolved'];
          bus_total=value.data()['bus_total'];
          bus_solved=value.data()['bus_solved'];
          bus_unsolved=value.data()['bus_unsolved'];
          health_total=value.data()['health_total'];
          health_solved=value.data()['health_solved'];
          health_unsolved=value.data()['health_unsolved'];
          sewage_total=value.data()['sewage_total'];
          sewage_solved=value.data()['sewage_solved'];
          sewage_unsolved=value.data()['sewage_unsolved'];
        }
      });
    });
    return data;
  }
getchartdata(){
  Map<String,double> pie_data={"Total Request":double.parse(total_count),
    "Solved Request":double.parse(solved_count),
    "Unsolved Request":double.parse(unsolved_count)};
  return pie_data;
}
getdept_wise_data(){
    Map<String,double> pie_data= {
    'Road':double.parse(road_total),
    'Transport/Bus':double.parse(bus_total),
    'Electrical':double.parse(electric_total),
    'Health':double.parse(health_total),
    'Sewage':double.parse(sewage_total),
    'Other':double.parse(other_total),};
    return pie_data;

}

  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.red
  ];

  List<Color> dept_wise_color=[
    Colors.amberAccent,
    Colors.pink[100],
    Colors.deepPurpleAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.orangeAccent
  ];

  Widget dept_card_with_image( var total,var solved,var unsolved,var dept,var color){
    return InkWell(
      onTap: (){
        Navigator.push(context, right_to_left_transition(child: see_deptwise_details(solved:'$solved', total: '$total', unsolved:'$unsolved',dept:'$dept'),),);
      },
      child: Column(children: [
        Padding(padding: EdgeInsets.only(top: 10),
        child: Text('$total',style: TextStyle(color:color,fontFamily: 'abrifatface',fontSize: 15),),
        ),
        Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
        child:Text('$dept',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),))
      ],),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(elevation: 0,actions: <Widget>[IconButton(icon: Icon(Icons.logout_rounded,color: Colors.orangeAccent,),onPressed: ()
        {firebaseAuth.signOut();
        Navigator.push(context, right_to_left_transition(child: Login_page(),),);
        },tooltip: "LogOut",)]
          ,backgroundColor: Colors.transparent,centerTitle: true,title: Text('Admin',style: TextStyle(color: Colors.orangeAccent,),),),
        body: FutureBuilder(
          future: get_data_form_firestore_admin(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              if(snapshot.hasError){
                return AlertDialog(title: const Text('Error:-',style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold,),),
                  content: Text('${snapshot.error}',style: TextStyle(fontSize: 12),),
                  actions:<Widget> [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],

                );
              }
              if(snapshot.hasData){
                return     SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10,top: 10),
                          child:Align(alignment: Alignment.topLeft,child: Text('Summary',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),),)
                      ),
                      SingleChildScrollView(
                          scrollDirection:Axis.horizontal,
                          child:
                              Padding(padding: EdgeInsets.all(10.0),
                                child: SizedBox(width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    elevation: 3,
                                    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)) ,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[

                                        dept_card_with_image(road_total, road_solved, road_unsolved, 'road',Colors.amberAccent),

                                        dept_card_with_image(electric_total, electric_solved, electric_unsolved,'electric',Colors.deepPurpleAccent),

                                        dept_card_with_image(bus_total, bus_solved, bus_unsolved,'bus',Colors.pink[200]),

                                        dept_card_with_image(health_total, health_solved, health_unsolved,'health',Colors.cyanAccent),

                                        dept_card_with_image(sewage_total, sewage_solved, sewage_unsolved,'sewage',Colors.purpleAccent),

                                        dept_card_with_image(other_total, other_solved, other_unsolved,'other',Colors.orangeAccent),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      SizedBox(height: 20.0,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
                          SizedBox(width: MediaQuery.of(context).size.width/2,
                            child: Card(elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(padding:EdgeInsets.only(left: 10,top: 10),
                                      child: Align(alignment: Alignment.topLeft,child: Text('All Data',style: TextStyle(fontSize: 10,color: Colors.orangeAccent,fontWeight: FontWeight.bold),))),
                                  SizedBox(height: 25,),

                                  PieChart(
                                    dataMap: getchartdata(),
                                    animationDuration: Duration(seconds: 2),
                                    chartLegendSpacing: 40,
                                    chartRadius: MediaQuery.of(context).size.width /4,
                                    colorList: colorList,
                                    initialAngleInDegree: 0,
                                    chartType: ChartType.ring,
                                    ringStrokeWidth: 40,
                                    centerText: 'Overall',
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: true,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 1,
                                    ),
                                  ),
                                  SizedBox(height: 25,),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: MediaQuery.of(context).size.width/2,
                            child: Card(elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 10,left: 10),
                                      child: Align(alignment: Alignment.topLeft,child: Text('Dept Wise Data',style: TextStyle(fontSize: 10,color: Colors.orangeAccent,fontWeight: FontWeight.bold),))),
                                  SizedBox(height: 25,),
                                  PieChart(
                                    dataMap: getdept_wise_data(),
                                    animationDuration: Duration(seconds: 2),
                                    chartLegendSpacing: 40,
                                    chartRadius: MediaQuery.of(context).size.width / 4,
                                    colorList: dept_wise_color,
                                    initialAngleInDegree: 0,
                                    chartType: ChartType.ring,
                                    ringStrokeWidth: 40,
                                    centerText: 'Dept',
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: true,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      legendTextStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Container(child: charts.BarChart(
                                _generatedata(),
                                animate: true,
                                vertical: false,
                                barGroupingType: charts.BarGroupingType.grouped,
                                animationDuration: Duration(seconds: 1),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10,top: 30,right: 10),
                        child:Card(elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
                          child: Column(children:<Widget> [
                            Padding(padding: EdgeInsets.only(left: 10,top: 15,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('All Request',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),),
                                  Row(children: <Widget>[
                                    Text('$total_count',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),),
                                    SizedBox(width: 10,),
                                    Text('$solved_count',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.green),),
                                    SizedBox(width: 10,),
                                    Text('$unsolved_count',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.red),),
                                  ],),
                                ],
                              ),),
                            SizedBox(height: 10.0,),
                            SizedBox(height: MediaQuery.of(context).size.height/2,
                              child: ListView.builder(itemCount: length,itemBuilder: (BuildContext cntx,int index){
                                return SingleChildScrollView(scrollDirection: Axis.horizontal,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(padding:EdgeInsets.only(left: 10,right: 10,top: 10)
                                          ,child: InkWell(onTap: ()=> Navigator.push(context, scale_transition(child: view_complaint_details_admin(snapshot:snapshot.data[index],admin_email: current_email,)))
                                              ,child: Card(elevation: 3,child: card_display_complaint_record(snapshot,index)))),
                                    ));
                              }),
                            ),
                          ],),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return Center(child:CircularProgressIndicator());
          },



        ),
      );
  }
}
class BarTask {
  String task;
  double value;
  BarTask(this.task,this.value);
}