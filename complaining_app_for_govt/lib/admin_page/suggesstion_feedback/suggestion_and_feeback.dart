//@dart=2.9
import 'package:complaining_app_for_govt/admin_page/suggesstion_feedback/feedback.dart';
import 'package:complaining_app_for_govt/admin_page/suggesstion_feedback/suggestion_details.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class suggestion_and_feedback extends StatefulWidget {
  const suggestion_and_feedback({Key key}) : super(key: key);

  @override
  _suggestion_and_feedbackState createState() => _suggestion_and_feedbackState();
}
String suggestion_count,feedback_count;

class _suggestion_and_feedbackState extends State<suggestion_and_feedback> with SingleTickerProviderStateMixin{
  TabController _controller;
  Future get_data() async{
    await firestore.collection('count').doc(current_email).get().then((value) {
      suggestion_count=value.data()['suggestion_count'];
      feedback_count=value.data()['feedback_count'];
    });
    return suggestion_count;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=TabController(length: 2,vsync: this,initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(elevation: 0,backgroundColor: Colors.transparent,centerTitle: true,title: Text('Suggestion And Feedback',style: TextStyle(color: Colors.orangeAccent,),),),
      body: FutureBuilder(
        future: get_data(),
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
              return Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10,right: 10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,
                            children:<Widget> [
                              Column(
                                children: [
                                  Text('$suggestion_count',style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'abrifatface'),),
                                  SizedBox(height: 10,),
                                  Text('Suggestion',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('$feedback_count',style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'abrifatface'),),
                                  SizedBox(height: 10,),
                                  Text('Feedback',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                                ],
                              ),
                            ],),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
                        child:
                          Column(
                            children: [
                              TabBar(controller: _controller,
                                indicatorColor: Colors.deepPurpleAccent,
                                unselectedLabelColor: Colors.grey,
                                labelColor: Colors.deepPurpleAccent,
                                indicatorWeight: 3.0,
                                tabs: [
                                  Tab(text: "Suggestion",),
                                  Tab(text: "Feedback",),
                                ],),
                              SizedBox(
                                height: MediaQuery.of(context).size.height/1.5,
                                child: TabBarView(controller: _controller,children: [
                                  suggestion_details(),
                                  feedback(),
                                ]),
                              )
                            ],),

                      ),
                    ],);

            }
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
    );
  }
}
