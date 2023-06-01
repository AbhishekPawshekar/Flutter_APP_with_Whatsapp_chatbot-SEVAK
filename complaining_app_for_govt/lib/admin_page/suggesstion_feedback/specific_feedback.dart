//@dart=2.9
import 'package:complaining_app_for_govt/admin_page/home/solved_view_complaint.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class specific_feedback extends StatefulWidget {
  const specific_feedback({Key key}) : super(key: key);

  @override
  _specific_feedbackState createState() => _specific_feedbackState();
}
int feedback_data_length;
List feedback_data_list=[];

class _specific_feedbackState extends State<specific_feedback> {
  Widget general_feedback_details(AsyncSnapshot snapshot,int index) {
    return Column(
      children: <Widget>[
        Padding(padding:EdgeInsets.only(left: 20,top: 0.5),
            child: Align(alignment:Alignment.topLeft,child: Text('${snapshot.data[index]['id']}',style: TextStyle(color: Colors.grey,fontSize:10,fontWeight: FontWeight.bold),))),

        Padding(padding: EdgeInsets.only(left: 10,right: 10),
          child: Row(
            children: <Widget>[
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
                ),
                child: Expanded(child: Text('${snapshot.data[index]['feedback']}',style: TextStyle(color: Colors.orangeAccent,fontSize:10),)),
              ),
            ],),
        ),
        Row(
          children:<Widget> [
            Text('Problem: ',style: TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
            Expanded(child: Text('${snapshot.data[index]['problem']}',style: TextStyle(color: Colors.grey,fontSize:10),))
          ],
        ),
        Row(
          children:<Widget> [
            Text('Location: ',style: TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
            Expanded(child: Text('${snapshot.data[index]['location']}',style: TextStyle(color: Colors.grey,fontSize:10),))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:<Widget> [
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
              ),
              child: Expanded(child: Text('Dept: ${snapshot.data[index]['dept']}',style: TextStyle(color: Colors.orangeAccent,fontSize:10),)),
            ),
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
              ),
              child: Expanded(child: Text('mobile: ${snapshot.data[index]['mobile_no']}',style: TextStyle(color: Colors.orangeAccent,fontSize:10),)),
            ),
            InkWell(onTap: (){
              int feedbackcount;
              firestore.collection('feedback').doc(snapshot.data[index]['id']+snapshot.data[index]['count_no']).delete();
              firestore.collection('count').doc(current_email).get().then((value) {
                if(value.exists) {
                  feedbackcount = int.parse(value.data()['feedback_count']);
                }
              }).whenComplete(() {
                feedbackcount-=1;
                firestore.collection('count').doc(current_email).update({
                  'feedback_count': feedbackcount.toString(),
                }).whenComplete(() {
                 showToast('Feedback Deleted..!!');
                });

              });


            },
                child: Icon(Icons.delete,size:20,)),
          ],),


      ],);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: ListView.builder(itemCount: feedback_data_length,itemBuilder: (BuildContext context,int index){
                    return SingleChildScrollView(scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(padding:EdgeInsets.only(left: 10,right: 10,top: 10)
                              ,child: Card(elevation: 3,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  child:general_feedback_details(snapshot,index))),
                        ));
                  }),
                ),
              );
            }
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
    );
  }
  Future get_data() async {
    List data=await get_data_with_2_where_condition('feedback','area',current_email,'type','specific');
    feedback_data_length=await data[0];
    return data[1];
  }
}
