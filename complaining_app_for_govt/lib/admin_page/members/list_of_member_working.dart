//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/admin_page/home/solved_view_complaint.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class list_of_member_woking extends StatefulWidget {
  var department;
  list_of_member_woking({Key key,@required this.department}) : super(key: key);

  @override
  _list_of_member_wokingState createState() => _list_of_member_wokingState(department);
}

void searchstart(String val) {}

String sufix='_work_members';

class _list_of_member_wokingState extends State<list_of_member_woking> {
  var department;
  int total_member_count,dept_member_count;
  _list_of_member_wokingState(this.department);
  var search=TextEditingController();

  Widget _member_details_card( var index,var snapshot){
    return Column(
      children: <Widget>[
        SizedBox(
          width: 150,
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              border: Border.all(
                  color: Colors.orange, // Set border color
                  width: 1.0),   // Set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)),
                boxShadow: [BoxShadow(blurRadius: 10,color: Colors.grey,offset: Offset(1,3))] // Make rounded corner of border
              // Set rounded corner radius
              // Make rounded corner of border
            ),
            child:
                Text('${snapshot[index]['name']}',style: TextStyle(color: Colors.white,fontSize:12),),

          ),
        ),

        Padding(padding: EdgeInsets.only(top:10,left: 10),
          child: Row(
            children: <Widget>[
              Text('Mobile No : ',style: TextStyle(color: Colors.orange,fontSize: 12,fontWeight: FontWeight.bold),),
              Text('${snapshot[index]['mobile_no']}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize:12),),
            ],),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text('${snapshot[index]['email']}',style: TextStyle(color: Colors.orangeAccent,fontSize:12,fontWeight: FontWeight.bold),)),
          Padding(padding: EdgeInsets.only(right: 10),
              child: InkWell(onTap: (){firestore.collection('working_members').doc('${snapshot[index]['email']}').delete().catchError((error)=>print('error in deleting $error')).whenComplete(() {
               firestore.collection('count').doc(current_email).get().then((value){
                 if(value.exists){
                   total_member_count=int.parse(value.data()['total_member']);
                   dept_member_count=int.parse(value.data()['$department'+'_member_count']);
                 }
               }).whenComplete(() {
                 total_member_count-=1;
                 dept_member_count-=1;
                 firestore.collection('count').doc(current_email).update({
                   'total_member': total_member_count.toString(),
                   '$department'+'_member_count': dept_member_count.toString(),
                 }).whenComplete(() {
                   var admin_email=current_email;
                   var admin_password;
                   firestore.collection('admin').doc(admin_email).get().then((value) {
                     admin_password=value.data()['password'];

                   }).whenComplete(() async {
                     await firebaseAuth.signInWithEmailAndPassword(email:'${snapshot[index]['email']}' , password:'${snapshot[index]['password']}').whenComplete(() async{
                       await firebaseAuth.currentUser.delete();
                       firebaseAuth.signInWithEmailAndPassword(email: admin_email, password: admin_password);
                     });

                   });

                 }).whenComplete(() {
                   showToast("SuccessFully Deleted That Member...");
                 });
               });
              });
              
              
              },
                  child: Icon(Icons.delete,size: 20,))),
        ],),

        SizedBox(height: 10,),
      ],
    );
  }

  var length;
  get_member_data()async{
    List data=await get_data_with_2_where_condition('working_members','dept',department, 'area',current_email);
    length=await data[0];
    return await data[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(elevation: 0,leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.orangeAccent,), onPressed: () {Navigator.pop(context, false) ; },),backgroundColor: Colors.transparent,centerTitle: true,title: Text('$department',style: TextStyle(color: Colors.orangeAccent,),),),
      body: FutureBuilder(
      future: get_member_data(),
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
            return Column(children:<Widget> [
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                child: TextField(keyboardType: TextInputType.text,textCapitalization: TextCapitalization.sentences,controller:search,
                  onChanged: (val){searchstart(val);},
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.search_rounded,color: Colors.orangeAccent,),hintText: 'Search For Event..'),
                  style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(child:ListView.builder(itemCount: length,itemBuilder: (context,index){
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,child: _member_details_card(index, snapshot.data),);
              })),

            ],);
          }
        }
        return Center(child: CircularProgressIndicator(),);
      }),
    );
  }


}
