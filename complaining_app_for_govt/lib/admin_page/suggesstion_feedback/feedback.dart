//@dart=2.9
import 'package:complaining_app_for_govt/admin_page/suggesstion_feedback/specific_feedback.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'general_feedback_details.dart';

class feedback extends StatefulWidget {
  const feedback({Key key}) : super(key: key);

  @override
  _feedbackState createState() => _feedbackState();
}


class _feedbackState extends State<feedback> with SingleTickerProviderStateMixin{
  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=TabController(length: 2,vsync: this,initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:  Column(
                children: <Widget>[
                        TabBar(controller: _controller,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.green,
                          indicatorWeight: 3.0,
                          tabs: [
                            Tab(text: "General",icon: Icon(Icons.radio_button_checked_rounded,size: 15,),),
                            Tab(text: "Specific",icon: Icon(Icons.radio_button_checked_rounded,size: 15,),),
                          ],),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/1.8,
                          child: TabBarView(controller: _controller,children: [
                            general_feedback_details(),
                            specific_feedback(),
                          ]),
                        )

                ],),
    );
  }
}
