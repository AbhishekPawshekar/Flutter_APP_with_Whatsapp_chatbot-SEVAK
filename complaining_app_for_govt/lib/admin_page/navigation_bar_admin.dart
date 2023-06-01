//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/admin_page/members/members.dart';
import 'package:complaining_app_for_govt/admin_page/suggesstion_feedback/suggestion_and_feeback.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:complaining_app_for_govt/admin_page/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
class navigationbar_controlleradmin extends StatefulWidget {
  const navigationbar_controlleradmin({Key key}) : super(key: key);

  @override
  _navigationbar_controlleradminState createState() => _navigationbar_controlleradminState();
}

class _navigationbar_controlleradminState extends State<navigationbar_controlleradmin> {
  int selected_index=0;
  final select_screen=[home_admin(),members(),suggestion_and_feedback()];
  DateTime currentdatetimepress;
  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: onwillpop,
    child: Scaffold(
      bottomNavigationBar:CurvedNavigationBar(
        height: 50.0,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.orangeAccent,
        items: <Widget>[
          Icon(Icons.home,size: 30,color: Colors.white,),
          Icon(Icons.person_add_alt_1_rounded,size: 30,color: Colors.white,),
          Icon(Icons.dynamic_feed_rounded,size: 30,color: Colors.white,),
        ],color: Colors.orangeAccent,
        onTap: (index){
          setState((){selected_index=index;});
        },
      ),
      body: select_screen[selected_index],
    )
    );
  }

  Future<bool> onwillpop()async {
    DateTime currenttime=DateTime.now();
    bool backpress=currentdatetimepress==null || currenttime.difference(currentdatetimepress)>Duration(seconds: 2);
    if(backpress){
      currentdatetimepress=currenttime;
      Fluttertoast.showToast(msg: 'Double Click To Exit.!!',toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM,timeInSecForIosWeb: 1,backgroundColor: Colors.grey,textColor: Colors.white);
      return false;
    }
    return true;
  }
}
