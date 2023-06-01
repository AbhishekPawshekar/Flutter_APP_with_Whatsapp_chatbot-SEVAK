//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_page/navigation_bar_admin.dart';
import 'head_of_dept/bus_transport_head.dart';
import 'head_of_dept/electric_work_head.dart';
import 'head_of_dept/health_services_head.dart';
import 'head_of_dept/other_compaint_head.dart';
import 'head_of_dept/road_work_head.dart';
import 'head_of_dept/sewage_and_sanitation_head.dart';
import 'login_and_registration_dart_file/login_page.dart';
FirebaseFirestore firestore=FirebaseFirestore.instance;
FirebaseAuth  firebaseAuth=FirebaseAuth.instance;
var current_email=firebaseAuth.currentUser.email;

get_user_dept_details_for_screen_to_load()async{
  try {var admin_email;
  // Get reference to Firestore collection
  if(firebaseAuth.currentUser!=null){
    String Doc_id =firebaseAuth.currentUser.email;
    var admin_collection = await firestore.collection('admin').doc(Doc_id).get();
    if(admin_collection.exists){
      return navigationbar_controlleradmin();
    }
    else {
      var head_of_dept_collection =await firestore.collection('head_of_dept').doc(Doc_id+'road').get().then((value) {
        if (value.exists){
          admin_email=value.data()['area'];
        }
      });
      if(head_of_dept_collection !=null){
        return road_work_headState(admin_email: admin_email,);
      }
      else {
        var head_of_dept_collection =await firestore.collection('head_of_dept').doc(Doc_id+'bus').get().then((value) {
          if (value.exists){
            admin_email=value.data()['area'];
          }
        });
        if(head_of_dept_collection !=null){
          return bus_transport_headState(admin_email: admin_email,);
        }
        else {
          var head_of_dept_collection =await firestore.collection('head_of_dept').doc(Doc_id+'electric').get().then((value) {
            if (value.exists){
              admin_email=value.data()['area'];
            }
          });
          if(head_of_dept_collection !=null){
            return electric_work_headState(admin_email: admin_email,);
          }
          else {
            var head_of_dept_collection =await firestore.collection('head_of_dept').doc(Doc_id+'sewage').get().then((value) {
              if (value.exists){
                admin_email=value.data()['area'];
              }
            });
            if(head_of_dept_collection !=null){
              return sewage_and_sanitation_headState(admin_email: admin_email,);
            }else {
              var head_of_dept_collection =await firestore.collection('head_of_dept').doc(Doc_id+'health').get().then((value) {
                if (value.exists){
                  admin_email=value.data()['area'];
                }
              });
              if(head_of_dept_collection !=null){
                return health_services_headState(admin_email: admin_email,);
              }
              else {
                var head_of_dept_collection = await firestore.collection('head_of_dept').doc(Doc_id + 'other').get().then((value) {
                  if (value.exists){
                    admin_email=value.data()['area'];
                  }
                });
                if (head_of_dept_collection !=null) {
                  return other_compaint_headState(admin_email: admin_email,);
                }

                //check as member
                else {
                  var dept;
                  await firestore.collection('working_members').doc(Doc_id).get().then((value) {
                    if (value.exists){
                      dept=value.data()['dept'];
                      admin_email=value.data()['area'];
                    }
                  });
                  if (dept!=null) {
                    if ( await dept=='road'){
                      return road_work_headState(admin_email: admin_email,);
                    }
                    if ( await dept=='bus'){
                      return bus_transport_headState(admin_email: admin_email,);
                    }
                    if ( await dept=='electric'){
                      return electric_work_headState(admin_email: admin_email,);
                    }
                    if (await  dept=='health'){
                      return health_services_headState(admin_email: admin_email,);
                    }
                    if ( await dept=='sewage'){
                      return sewage_and_sanitation_headState(admin_email: admin_email,);
                    }
                    if ( await dept =='other'){
                      return other_compaint_headState(admin_email: admin_email,);
                    }
                  }else{
                    print('user no found');
                  }
                }
              }
            }
          }
        }

      }

    }
  }else{
    return Login_page();
  }
  }
  catch (e) {
    throw e;
  }
}
get_data_with_2_where_condition(String collection_name,String field1,String value1,String field2,String value2)async{
  List data=[];
  int length;
  await firestore.collection('$collection_name').where('$field1',isEqualTo:'$value1').where('$field2',isEqualTo:'$value2').get().then((value){
    if(value!=null){
      value.docs.forEach((element) {
        data.add(element.data());
      });
      length =value.docs.length;
    }
  });
  return [length,data];
}
get_data_from_dept_head(String collection_name,String field1,String value1,String field2,String value2)async{
  List data=[];
  int length;
  String total,solved,unsolved;
  await firestore.collection('$collection_name').where('$field1',isEqualTo:'$value1').where('$field2',isEqualTo: '$value2').get().then((value){
    value.docs.forEach((element) {
      data.add(element.data());
    });
    length=value.docs.length;
  }).whenComplete(()async {
    await firestore.collection("count").doc('$value1').get().then((value) {
      if(value.exists){
        total=value.data()['$value2'+'_total'];
        solved=value.data()['$value2'+'_solved'];
        unsolved=value.data()['$value2'+'_unsolved'];
      }
    });
  });
  return [length,data,total,solved,unsolved];
}

