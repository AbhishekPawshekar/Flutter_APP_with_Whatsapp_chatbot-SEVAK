//@dart=2.9
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../write_data_to_firestore.dart';
class unsolved_view_complaint extends StatefulWidget {
  final snapshot;
  var admin_email;
  unsolved_view_complaint({Key key,@required this.snapshot,@required this.admin_email}):super(key: key);

  @override
  _unsolved_view_complaintState createState() => _unsolved_view_complaintState(snapshot,admin_email);
}
enum choose_option{solved_request,unsolved_request}
final comment=TextEditingController();
final reason=TextEditingController();
void showToast(String msg){
  Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,backgroundColor: Colors.orangeAccent,textColor: Colors.white);
}
String url;
XFile _file_image;
upload_data_and_image_ToFireStoreage_complaint(String comment,final snapshot,var admin_email)async {
  String fileName = basename(_file_image.path);
  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('${snapshot['dept']}/$fileName');
  UploadTask uploadTask=firebaseStorageRef.putFile(File(_file_image.path));
  await uploadTask.whenComplete(()async{
    url= (await firebaseStorageRef.getDownloadURL()).toString();
    showToast('Image successfully uploaded ..!!');
    action_taken_complaints_in_firestore_admin_change_to_saved(url, comment, snapshot,admin_email);
  });

}

class _unsolved_view_complaintState extends State<unsolved_view_complaint> {
  final snapshot;
  var admin_email;
  bool checkedvalue=false;
  int id=1;
  choose_option choose=choose_option.solved_request;
  _unsolved_view_complaintState(this.snapshot,this.admin_email);
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
                          Text('solved Incident Image.!!',style: TextStyle(color: Colors.orangeAccent,fontFamily: 'cinzelbold',fontWeight: FontWeight.bold),),
                        ],),
                      ),
                    ),),
                ),
              ),
              Padding(padding:EdgeInsets.only(left: 10,right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: Column(children:<Widget> [
                    SizedBox(
                      width: 150,
                      child: Container(
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
                        child:
                            Text('Information ',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  Padding(padding:EdgeInsets.only(left: 10,top: 20),
                    child: Row(children:<Widget>[
                      Text('Problem:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                      Expanded(child: Text('${snapshot['problem']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                    ]),),
                  Padding(padding:EdgeInsets.only(left: 10,top: 10),
                    child: Row(children:<Widget>[
                      Text('Location:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                      Expanded(child: Text('${snapshot['location']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                    ]),),
                    Padding(padding: EdgeInsets.only(left: 10,top: 10),
                  child: Row(
                      children: <Widget>[
                        Text('Status:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                        Expanded(child: Text('${snapshot['status']}',style: TextStyle(color: Colors.orangeAccent,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'cinzelbold'),maxLines: 2,overflow: TextOverflow.ellipsis,),),
                      ],),
                    ),
                  ],),
                ),
              ),

              SizedBox(height: 20,),
              Container(height: 1,color: Colors.orange,width: MediaQuery.of(context).size.width,),
              Center(child:Text('Action Taken',style: TextStyle(color: Colors.orangeAccent,fontSize: 16),)),
              Align(alignment: Alignment.topRight,child: Padding(padding:EdgeInsets.only(left: 10,top: 20),
                child: Row(children:<Widget>[
                  Text('Reason Of Action:',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                  Expanded(child: Text('${snapshot['comment']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12),maxLines: 5,overflow: TextOverflow.ellipsis,),)
                ]),),),
              SizedBox(height: 10,),
              CheckboxListTile(
                title: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      border: Border.all(
                          color: Colors.orange, // Set border color
                          width: 1.0),   // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                      boxShadow: [BoxShadow(blurRadius: 10,color: Colors.grey,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child:
                      Text('Add To Solved Complaint',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),)
                ),
                value:checkedvalue,
                onChanged: (newValue) {
                  setState(() {
                    checkedvalue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
                (checkedvalue)?Column(children:<Widget> [
                  InkWell(
                    onTap:()async{
                      XFile file=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 25);
                      setState(() {
                        _file_image=file;
                      });
                    },
                    child:(_file_image!=null)?Image.file(File(_file_image.path),fit: BoxFit.fill,):

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
                              Icon(Icons.cloud_upload_rounded,size: 50,color: Colors.orangeAccent,),
                              Text(' Solved Incident Image.!!',style: TextStyle(color: Colors.orangeAccent,fontFamily: 'cinzelbold',fontWeight: FontWeight.bold),),
                            ],),
                          ),
                        ),),

                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                    child: TextFormField(keyboardType: TextInputType.multiline,textCapitalization: TextCapitalization.sentences,controller:comment,maxLines: 5,maxLength: 250,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.comment_bank_rounded,color: Colors.orangeAccent,),hintText: "Any Comment's..."),
                      style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height:1.5 ,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(padding: EdgeInsets.fromLTRB(30,20.0,30.0,00.0),
                        child: ElevatedButton(onPressed: (){
                          upload_data_and_image_ToFireStoreage_complaint(comment.text,snapshot,admin_email);
                          showToast('update Successfully..!!');
                          //Navigator.push(context, CustomPage(child:enter_location_of_complaint()));
                        },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)))),
                          child:  Text('Submit.',style: TextStyle(color: Colors.white,fontSize: 14.0,)),
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                ],):
                    Column(children: <Widget>[
                      Container(),
                    ],),

            ]) ,
      ) ,
    );
  }
}
