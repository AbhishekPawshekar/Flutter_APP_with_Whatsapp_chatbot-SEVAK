//@dart=2.9

import 'package:complaining_app_for_govt/admin_page/members/add_members.dart';
import 'package:complaining_app_for_govt/admin_page/members/list_of_member_working.dart';
import 'package:complaining_app_for_govt/all_screen_transition.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class members extends StatefulWidget {
  @override
  _membersState createState() => _membersState();
}
_buildCard({
  Config config,
  Color backgroundColor = Colors.transparent,
  double height = 100.0,
}) {
  return Container(
    height: height,
    width: double.infinity,
    child:  WaveWidget(
        config: config,
        backgroundColor: backgroundColor,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 5,
      ),

  );
}

class _membersState extends State<members>{

  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  int _blurIndex = 0;
  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex];
    return _blurs[_blurIndex];
  }

  List<charts.Series<BarTask,String>> bardata;
_generatedata(double roadcount,double electriccount,double buscount,double healthcount,double sewage_sanitationcount){
  var data=[new BarTask('Road',roadcount),
    new BarTask('Electrical', electriccount),
    new BarTask('Bus', buscount,),
    new BarTask('Health',healthcount,),
    new BarTask('Sewage', sewage_sanitationcount,),
  ];
  bardata.add(
    charts.Series(
      domainFn: (BarTask bartask,_)=>bartask.task,
      measureFn:(BarTask bartask,_)=>bartask.value,
      data: data,
      fillColorFn: (BarTask bartask,_)=>charts.ColorUtil.fromDartColor(Colors.amber),
      fillPatternFn: (_,__)=>charts.FillPatternType.solid,
    ),
  );
  return bardata;
}
var roadhead,electrichead,bushead,sewagehead,healthhead,otherhead;
get_head_of_dept_data()async{
  await firestore.collection('head_of_dept').where('area',isEqualTo:current_email).get().then((value) {
    value.docs.forEach((element) {
      if(element.exists){
        if(element.data()['dept']=='road'){
          roadhead=element.data()['name'];
        }
        else if(element.data()['dept']=='electric'){
          roadhead=element.data()['name'];
        }
        else if(element.data()['dept']=='bus'){
          roadhead=element.data()['name'];
        }
        else if(element.data()['dept']=='health'){
          roadhead=element.data()['name'];
        }
        else if(element.data()['dept']=='sewage'){
          roadhead=element.data()['name'];
        }
        else if(element.data()['dept']=='other'){
          roadhead=element.data()['name'];
        }
      }
    });
  });
}
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    bardata=List<charts.Series<BarTask,String>>();
    get_head_of_dept_data();
}
  Widget display_head_of_dept_details( var head_name,var count,var dept_name){
    return  Container(
      width: 150,
      height: 150,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:<Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.people_alt_sharp,size: 20,color: Colors.amber,),
                Text('$head_name',style:TextStyle(color: Colors.cyan,fontSize: 10),),
              ],
            ),
            Text('$count',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'abrifatface',letterSpacing: 2,fontSize: 18),),
            Padding(padding: EdgeInsets.only(left: 10),
                child: Align(alignment:Alignment.topLeft,child: Text('$dept_name',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'cinzelbold',fontSize: 12,),))),
          ],
        ) ,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(elevation: 0,backgroundColor: Colors.transparent,centerTitle: true,title: Text('Members',style: TextStyle(color: Colors.orangeAccent,),),),
        body:FutureBuilder(
          future:firestore.collection('count').doc(current_email).get(),
          builder: (_,snapshot){
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
                  child: Stack(
                    children:<Widget> [
                      ClipPath(
                        clipper: clip_member(),
                        child:  Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/3,
                          child: _buildCard(
                            backgroundColor: Colors.transparent,
                            config: CustomConfig(
                              gradients: [
                                [Colors.red, Color(0xEEF44336)],
                                [Colors.red, Color(0x77E57373)],
                                [Colors.orange, Color(0x66FF9800)],
                                [Colors.yellow, Color(0x55FFEB3B)]
                              ],
                              durations: [35000, 19440, 10800, 6000],
                              heightPercentages: [0.20, 0.23, 0.25, 0.30],
                              blur: _blur,
                              gradientBegin: Alignment.bottomLeft,
                              gradientEnd: Alignment.topRight,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text('${snapshot.data['total_member']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'abrifatface',letterSpacing: 2,fontSize: 18),),
                          ),
                          SizedBox(height: 5,),
                          Center(
                            child: Text('Total Members',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.amber),),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/6,),
                          Align(alignment: Alignment.topRight,
                            child: Card(
                              margin: EdgeInsets.only(right: 10),
                              elevation: 10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                              child:InkWell(
                                onTap: (){
                                  Navigator.push(context, right_to_left_transition(child: add_members(),),);
                                },
                                child: Icon(Icons.add_circle,size: 40,color: Colors.orangeAccent,),
                              ),
                            ),),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Container(child: charts.BarChart(
                                _generatedata(double.parse('${snapshot.data['road_member_count']}'),double.parse('${snapshot.data['electric_member_count']}'), double.parse('${snapshot.data['bus_member_count']}'), double.parse('${snapshot.data['health_member_count']}'), double.parse('${snapshot.data['sewage_member_count']}')),
                                animate: true,
                                barGroupingType: charts.BarGroupingType.stacked,
                                animationDuration: Duration(seconds: 1),
                              )),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20,left: 10,bottom: 10),child: Align(alignment: Alignment.topLeft,child: Text('Department Count',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.bold),),)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  InkWell(onTap:(){Navigator.push(context, right_to_left_transition(child: list_of_member_woking(department:'road'),),);}
                                  ,child: display_head_of_dept_details(roadhead,snapshot.data['road_member_count'],'road')),
                                  SizedBox(width: 10,),
                                  InkWell(onTap: (){Navigator.push(context, right_to_left_transition(child:list_of_member_woking(department:'electric'),),);}
                                  ,child: display_head_of_dept_details(electrichead,snapshot.data['electric_member_count'],'electrical')),
                                  SizedBox(width: 10,),
                                  InkWell(onTap: (){Navigator.push(context, right_to_left_transition(child:list_of_member_woking(department:'bus'),),);}
                                  ,child: display_head_of_dept_details(bushead,snapshot.data['bus_member_count'],'bus')),
                                  SizedBox(width: 10,),
                                  InkWell(onTap: (){Navigator.push(context, right_to_left_transition(child:list_of_member_woking(department:'health'),),);}
                                  ,child: display_head_of_dept_details(healthhead,snapshot.data['health_member_count'],'health')),
                                  SizedBox(width: 10,),
                                  InkWell(onTap: (){Navigator.push(context, right_to_left_transition(child:list_of_member_woking(department:'sewage'),),);}
                                  ,child: display_head_of_dept_details(sewagehead,snapshot.data['sewage_member_count'],'sewage')),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ),
                        ],
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

class clip_member extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path=Path();
    path.lineTo(0.0, size.height/4);
    var first_control_point=Offset(size.width/15, size.height/1.5);
    var first_ending_point=Offset(size.width/2-50,size.height-50);
    path.quadraticBezierTo(first_control_point.dx, first_control_point.dy, first_ending_point.dx,first_ending_point.dy);

    var second_control_point=Offset(size.width/2, size.height-40);
    var second_ending_point=Offset(size.width/2+50,size.height-50);
    path.quadraticBezierTo(second_control_point.dx, second_control_point.dy, second_ending_point.dx,second_ending_point.dy);

    var third_control_point=Offset(size.width/1.1, size.height/1.5);
    var third_ending_point=Offset(size.width,size.height/4);
    path.quadraticBezierTo(third_control_point.dx, third_control_point.dy, third_ending_point.dx,third_ending_point.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}

class BarTask {
  String task;
  double value;
  BarTask(this.task,this.value);
}