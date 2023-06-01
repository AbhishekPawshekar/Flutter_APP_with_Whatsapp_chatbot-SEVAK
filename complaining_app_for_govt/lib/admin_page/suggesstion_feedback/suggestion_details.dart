//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/admin_page/home/view_complaint_details_admin.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class suggestion_details extends StatefulWidget {
  const suggestion_details({Key key}) : super(key: key);

  @override
  _suggestion_detailsState createState() => _suggestion_detailsState();
}

String choose='suggestion';
int suggestion_data_length;

List suggestion_data_list=[];
class _suggestion_detailsState extends State<suggestion_details> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future get_data() async{
    await firestore.collection('suggestion').where('area',isEqualTo: current_email).get().then((value) {
      value.docs.forEach((element) {
        suggestion_data_list.add(element.data());
      });
      suggestion_data_length=value.docs.length;
    });
    return suggestion_data_list;
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
                child: suggestion_data_display(snapshot),
              );
            }
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
    );
  }

  Widget suggestion_data_display(AsyncSnapshot snapshot){
    return SingleChildScrollView(
      child: SizedBox(height: MediaQuery.of(context).size.height,
        child: ListView.builder(itemCount: suggestion_data_length,itemBuilder: (BuildContext context,int index){
          return  Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(padding:EdgeInsets.only(left: 10,right: 10,top: 10)
                ,child: Card(elevation: 3,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child:suggestion_details_card(snapshot,index))),
          );
        }),
      ),
    );
  }

  Widget suggestion_details_card(AsyncSnapshot snapshot,int index) {
    return
      Column(
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
                  child: Expanded(child: Text('${snapshot.data[index]['suggestion']}',style: TextStyle(color: Colors.orangeAccent,fontSize:10),)),
                ),
              ],),
          ),
          Padding(padding: EdgeInsets.only(right: 10,bottom: 0.5),
            child: Align(alignment:Alignment.topRight,
              child: InkWell(onTap: (){
                int suggestioncount;
              firestore.collection('suggestion').doc('${snapshot.data[index]['id']}'+'${snapshot.data[index]['count_no']}').delete();
              firestore.collection('count').doc(current_email).get().then((value) {
                if(value.exists) {
                  suggestioncount = int.parse(value.data()['suggestion_count']);
                }
              }).whenComplete(() {
                suggestioncount-=1;
                firestore.collection('count').doc(current_email).update({
                  'feedback_count': suggestioncount.toString(),
                }).whenComplete(() {
                  showToast('Suggestion Deleted..!!');
                });

              });

              },
                child: Icon(Icons.delete,size:20,)),),
          ),
        ],);

  }
}
