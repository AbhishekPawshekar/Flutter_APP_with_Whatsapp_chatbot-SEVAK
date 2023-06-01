//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/admin_page/home/solved_view_complaint.dart';
import 'package:complaining_app_for_govt/admin_page/home/unsolved_view_complaint.dart';
import 'package:complaining_app_for_govt/admin_page/home/view_complaint_details_admin.dart';
import 'package:complaining_app_for_govt/login_and_registration_dart_file/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../read_data_form_firestore.dart';
import '../all_screen_transition.dart';
class bus_transport_headState extends StatefulWidget {
  var admin_email;
  bus_transport_headState({Key key,@required this.admin_email}):super(key: key);

  @override
  _bus_transportState_headState createState() => _bus_transportState_headState(admin_email);
}

class _bus_transportState_headState extends State<bus_transport_headState> {
  String bus_total,bus_unsolved,bus_solved;
  var admin_email;
  _bus_transportState_headState(this.admin_email);
  select_which_screen_to_load(final snapshot,String request_choice){
    if(request_choice=="total_request"){
      return view_complaint_details_admin(snapshot:snapshot,admin_email: admin_email,);
    }else if(request_choice=="solved_request"){
      return solved_view_complaint(snapshot:snapshot);
    }
    else{
      return unsolved_view_complaint(snapshot: snapshot,admin_email: admin_email,);
    }

  }
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
                    Row(
                      children: <Widget>[
                        Text('Name : ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                        Text('${dataFormFirestore.data[index]['name']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),),
                      ],),
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

  int length;
  String request_choice = 'total_request';
  get_data_form_firestore_admin()async{
    List data=await get_data_from_dept_head(request_choice, 'area', admin_email,'dept','bus');
    length=await data[0];
    bus_total=await data[2];
    bus_solved= await data[3];
    bus_unsolved=await data[4];
    return await data[1];
  }
  getchartdata(){
    Map<String,double> pie_data={"Total Request":double.parse(bus_total),
      "Solved Request":double.parse(bus_solved),
      "Unsolved Request":double.parse(bus_unsolved)};
    return pie_data;
  }
  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.red
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(elevation: 0,actions: <Widget>[IconButton(icon: Icon(Icons.logout_rounded,color: Colors.orangeAccent,),onPressed: ()
      {FirebaseAuth.instance.signOut();
      Navigator.push(context, right_to_left_transition(child: Login_page(),),);
      },tooltip: "LogOut",)]
        ,backgroundColor: Colors.transparent,centerTitle: true,title: Text('Municipal Bus',style: TextStyle(color: Colors.orangeAccent,),),),
      body: FutureBuilder(
        future: get_data_form_firestore_admin(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            if(snapshot.hasError){
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18),
                ),
              );}
            if(snapshot.hasData){
              return  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 10,top: 10),
                        child:Align(alignment: Alignment.topLeft,child: Text('Summary',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),),)
                    ),

                    SizedBox(height: 20.0,),
                    Row(mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children:<Widget> [
                        Column(
                          children: [
                            Text('$bus_total',style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'abrifatface'),),
                            SizedBox(height: 10,),
                            Text('Total',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                          ],
                        ),
                        Column(
                          children: [
                            Text('$bus_solved',style: TextStyle(color: Colors.green,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'abrifatface'),),
                            SizedBox(height: 10,),
                            Text('Solved',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                          ],
                        ),
                        Column(
                          children: [
                            Text('$bus_unsolved',style: TextStyle(color: Colors.redAccent,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'abrifatface'),),
                            SizedBox(height: 10,),
                            Text('Unsolved',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                          ],
                        ),
                      ],),
                    SizedBox(height: 20.0,),

                    PieChart(
                      dataMap: getchartdata(),
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 40,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 40,
                      centerText: 'Bus',
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendTextStyle: TextStyle(
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
                    Padding(padding: EdgeInsets.only(right: 10,top: 10),
                      child: Align(alignment: Alignment.topRight,child:
                      DropdownButton<String>(
                        value: request_choice,
                        elevation: 16,
                        style: const TextStyle(color: Colors.cyan),
                        underline: Container(
                          height: 2,
                          color: Colors.orangeAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            request_choice = newValue;
                          });
                        },
                        items: <String>['total_request','solved_request','unsolved_request']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                      child:Card(elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
                        child: Column(children:<Widget> [
                          Padding(padding: EdgeInsets.only(left: 10,top: 15,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('All Request',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),),
                                Row(children: <Widget>[
                                  Text('$bus_total',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),),
                                  SizedBox(width: 10,),
                                  Text('$bus_solved',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.green),),
                                  SizedBox(width: 10,),
                                  Text('$bus_unsolved',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.red),),
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
                                        ,child: InkWell(onTap: ()=> Navigator.push(context, scale_transition (child: select_which_screen_to_load(snapshot.data[index],request_choice))),
                                            child: Card(elevation: 3,child: card_display_complaint_record(snapshot,index)))),
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
