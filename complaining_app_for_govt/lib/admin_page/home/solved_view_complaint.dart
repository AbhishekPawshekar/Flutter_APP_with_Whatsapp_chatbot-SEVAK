//@dart=2.9
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../write_data_to_firestore.dart';
class solved_view_complaint extends StatefulWidget {
  final snapshot;
  solved_view_complaint({Key key,@required this.snapshot}):super(key: key);

  @override
  _solved_view_complaintState createState() => _solved_view_complaintState(snapshot);
}
enum choose_option{solved_request,unsolved_request}
final comment=TextEditingController();
final reason=TextEditingController();
void showToast(String msg){
  Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,backgroundColor: Colors.orangeAccent,textColor: Colors.white);
}
String url;

class _solved_view_complaintState extends State<solved_view_complaint> {
  final snapshot;
  int id=1;
  String option_chooses='solved_request';
  choose_option choose=choose_option.solved_request;
  _solved_view_complaintState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.orangeAccent,), onPressed: () {Navigator.pop(context, false) ; }),centerTitle:true,title: Text('More Details',style: TextStyle(color: Colors.orangeAccent,),),backgroundColor: Colors.transparent,elevation: 0,),
      body:SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                child: (snapshot['complaint_image_url']!=null)?Image.network(snapshot['complaint_image_url']):
                DottedBorder(borderType: BorderType.RRect,
                  radius: Radius.circular(30),
                  strokeWidth: 1,
                  color: Colors.orangeAccent,
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.only(top: 130),
                        child: Column(children: <Widget>[
                          Icon(Icons.error_rounded,size: 50,color: Colors.orangeAccent,),
                          Text('Incident Image.!!',style: TextStyle(color: Colors.orangeAccent,fontFamily: 'cinzelbold',fontWeight: FontWeight.bold),),
                        ],),
                      ),
                    ),),
                ),
              ),
              Align(alignment: Alignment.topRight,child: Padding(padding:EdgeInsets.only(left: 10,top: 20),
                child: Row(children:<Widget>[
                  Text('Problem:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                  Expanded(child: Text('${snapshot['problem']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                ]),),),
              Align(alignment: Alignment.topRight,child: Padding(padding:EdgeInsets.only(left: 10,top: 10),
                child: Row(children:<Widget>[
                  Text('Location:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                  Expanded(child: Text('${snapshot['location']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                ]),),),  Padding(padding: EdgeInsets.only(left: 10,top: 10),
                child: Align(alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Text('Status:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                      Expanded(child: Text('${snapshot['status']}',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),maxLines: 2,overflow: TextOverflow.ellipsis,),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(height: 1,color: Colors.orange,width: MediaQuery.of(context).size.width,),
              Center(child:Text('Action Taken',style: TextStyle(color: Colors.orangeAccent,fontSize: 16),)),
              Padding(padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                child: (snapshot['solved_image_url']!=null)?Image.network(snapshot['solved_image_url']):
                DottedBorder(borderType: BorderType.RRect,
                  radius: Radius.circular(30),
                  strokeWidth: 1,
                  color: Colors.orangeAccent,
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.only(top: 130),
                        child: Column(children: <Widget>[
                          Icon(Icons.error_rounded,size: 50,color: Colors.orangeAccent,),
                          Text('solved Incident Image.!!',style: TextStyle(color: Colors.orangeAccent,fontFamily: 'cinzelbold',fontWeight: FontWeight.bold),),
                        ],),
                      ),
                    ),),
                ),
              ),
              Align(alignment: Alignment.topRight,child: Padding(padding:EdgeInsets.only(left: 10,top: 20),
                child: Row(children:<Widget>[
                  Text('Comment:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                  Expanded(child: Text('${snapshot['comment']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                ]),),),
              SizedBox(height: 20,),

            ]) ,
      ) ,
    );
  }
}
