//@dart=2.9

import 'package:complaining_app_for_govt/read_data_form_firestore.dart';

Future<void> action_taken_complaints_in_firestore_admin(String option_choose,String url,String comment,final snapshot,var admin_email)async{
  var collectionadmin=firestore.collection('count').doc(admin_email);
  var collectionuser=firestore.collection('user').doc('${snapshot['id']}');
  var collection_total_request=firestore.collection('total_request').doc('${snapshot['id']}'+'${snapshot['total_request']}');
  String solved_request,dept_solved_request,user_solved_request;
  String unsolved_request,dept_unsolved_request,user_unsolved_request;
  if(option_choose=='solved_request'){
    //set value to solved request
    await firestore.collection('solved_request').doc('${snapshot['id']}${snapshot['total_request']}').set({
      'dept':'${snapshot['dept']}',
      'id':'${snapshot['id']}',
      'count_no':'${snapshot['total_request']}',
      'complaint_image_url':'${snapshot['complaint_image_url']}',
      'area':'${snapshot['area']}',
      'time':'${snapshot['time']}',
      'date':'${snapshot['date']}',
      'status':'solved_complaint',
      'solved_image_url':url.toString(),
      'name':'${snapshot['name']}',
      'mobile_no':'${snapshot['mobile_no']}',
      'problem':'${snapshot['problem']}',
      'location':'${snapshot['location']}',
      'comment':comment.toString(),
    }).whenComplete(() async{
      //get value from admin
      await collectionadmin.get().then((value) {
        if(value.exists){
        dept_solved_request=value.data()['${snapshot['dept']}_solved'];
        solved_request=value.data()['solved_request'];
        }
      }).whenComplete(() async{
        //get value from user
        await collectionuser.get().then((value){
          user_solved_request=value.data()['solved_request'];
        }).whenComplete(() {
          collection_total_request.delete().catchError((error)=>print('error in deleting $error'))
              .whenComplete(() async{
                int dept_solved=int.parse(dept_solved_request);
                int solved=int.parse(solved_request);
                dept_solved+=1;
                solved+=1;
            await collectionadmin.update({
            '${snapshot['dept']}_solved':dept_solved.toString(),
            'solved_request':solved.toString(),
            }).whenComplete(() async{
              int user_solved=int.parse(user_solved_request);
             user_solved+=1;
              await collectionuser.update({
              'solved_request':user_solved.toString(),
              });
            });
          });
        });
      });
    });

  }else{
    await firestore.collection('unsolved_request').doc('${snapshot['id']}${snapshot['total_request']}').set({
      'dept':'${snapshot['dept']}',
      'id':'${snapshot['id']}',
      'count_no':'${snapshot['total_request']}',
      'complaint_image_url':'${snapshot['complaint_image_url']}',
      'area':'${snapshot['area']}',
      'time':'${snapshot['time']}',
      'date':'${snapshot['date']}',
      'status':'solved_complaint',
      'solved_image_url':url.toString(),
      'name':'${snapshot['name']}',
      'mobile_no':'${snapshot['mobile_no']}',
      'problem':'${snapshot['problem']}',
      'location':'${snapshot['location']}',
      'comment':comment.toString(),
    }).whenComplete(() async{
      //get value from admin
      await collectionadmin.get().then((value) {
        if(value.exists){
          dept_unsolved_request=value.data()['${snapshot['dept']}_unsolved'];
          unsolved_request=value.data()['unsolved_request'];
        }
      }).whenComplete(() async{
        //get value from user
        await collectionuser.get().then((value){
          user_unsolved_request=value.data()['unsolved_request'];
        }).whenComplete(() {
          collection_total_request.delete().catchError((error)=>print('error in deleting $error'))
              .whenComplete(() async{
            int dept_unsolved=int.parse(dept_unsolved_request);
            int unsolved=int.parse(unsolved_request);
            dept_unsolved+=1;
            unsolved+=1;
            await collectionadmin.update({
              '${snapshot['dept']}_unsolved':dept_unsolved.toString(),
              'unsolved_request':unsolved.toString(),
            }).whenComplete(() async{
              int user_unsolved=int.parse(user_unsolved_request);
              user_unsolved+=1;
              await collectionuser.update({
                'unsolved_request':user_unsolved.toString(),
              });
            });
          });
        });
      });
    });

  }

}

Future<void> action_taken_complaints_in_firestore_admin_change_to_saved(String url,String comment,final snapshot,var admin_email)async {
  var collectionadmin=firestore.collection('count').doc(admin_email);
  var collectionuser=firestore.collection('user').doc('${snapshot['id']}');
  var collection_unsolved_request=firestore.collection('unsolved_request').doc('${snapshot['id']}'+'${snapshot['count_no']}');
  String solved_request,dept_solved_request,user_solved_request;
  String unsolved_request,dept_unsolved_request,user_unsolved_request;
  //set value to solved request
  await firestore.collection('solved_request').doc('${snapshot['id']}'+'${snapshot['count_no']}').set({
    'dept':'${snapshot['dept']}',
    'id':'${snapshot['id']}',
    'count_no':'${snapshot['count_no']}',
    'complaint_image_url':'${snapshot['complaint_image_url']}',
    'area':'${snapshot['area']}',
    'time':'${snapshot['time']}',
    'date':'${snapshot['date']}',
    'status':'solved_complaint',
    'solved_image_url':url.toString(),
    'name':'${snapshot['name']}',
    'mobile_no':'${snapshot['mobile_no']}',
    'problem':'${snapshot['problem']}',
    'location':'${snapshot['location']}',
    'comment':comment.toString(),
  }).whenComplete(() async{
    //get value from admin
    await collectionadmin.get().then((value) {
      if(value.exists){
        dept_solved_request=value.data()['${snapshot['dept']}_solved'];
        solved_request=value.data()['solved_request'];
        unsolved_request=value.data()['unsolved_request'];
        dept_unsolved_request=value.data()['${snapshot['dept']}_unsolved'];
      }
    }).whenComplete(() async{
      //get value from user
      await collectionuser.get().then((value){
        user_unsolved_request=value.data()['unsolved_request'];
        user_solved_request=value.data()['solved_request'];
      }).whenComplete(() {
        collection_unsolved_request.delete().catchError((error)=>print('error in deleting $error'))
            .whenComplete(() async{
          int dept_solved=int.parse(dept_solved_request);
          int solved=int.parse(solved_request);
          int unsolved=int.parse(unsolved_request);
          int dept_unsolved=int.parse(dept_unsolved_request);
          dept_solved+=1;
          solved+=1;
          unsolved-=1;
          dept_unsolved-=1;
          await collectionadmin.update({
            '${snapshot['dept']}_solved':dept_solved.toString(),
            'solved_request':solved.toString(),
            'unsolved_request':unsolved.toString(),
            '${snapshot['dept']}_total':dept_unsolved.toString(),
          }).whenComplete(() async{
            int user_unsolved=int.parse(user_unsolved_request);
            int user_solved=int.parse(user_solved_request);
            user_unsolved-=1;
            user_solved+=1;
            await collectionuser.update({
              'unsolved_request':user_unsolved.toString(),
              'solved_request':user_solved.toString(),
            });
          });
        });
      });
    });
  });


}

Future<void> add_members_to_database(bool checkvalue,String department,String name,String phone,String email,String password)async{
  String membercounter,dept_count;
  int membercounter1,dept_count1;
if(checkvalue==true){
  if(department=="Road Department"){
    await firestore.collection('head_of_dept').doc(current_email+'road').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'road',
      'area':current_email,
    });
  }else if(department=="Bus Department"){
    await firestore.collection('head_of_dept').doc(current_email+'bus').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'bus',
      'area':current_email,
    });
  }
  else if(department=="Electric Department"){
    await firestore.collection('head_of_dept').doc(current_email+'electric').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'electric',
      'area':current_email,
    });
  }
  else if(department=="Health Department"){
    await firestore.collection('head_of_dept').doc(current_email+'health').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'health',
      'area':current_email,
    });
  }
  else if(department=="Sewage And Sanitation"){
    await firestore.collection('head_of_dept').doc(current_email+'sewage').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'sewage',
      'area':current_email,
    });
  }
  else if(department=="Other Department"){
    await firestore.collection('head_of_dept').doc(current_email+'other').update({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'other',
      'area':current_email,
    });

  }
}

else{
  if(department=="Road Department"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'road',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['road_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'road_member_count':dept_count1.toString(),

            });
      });
    });
  }else if(department=="Bus Department"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'bus',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['bus_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'bus_member_count':dept_count1.toString(),

            });
      });
    });
  }
  else if(department=="Electric Department"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'electric',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['electric_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'electric_member_count':dept_count1.toString(),

            });
      });
    });
  }
  else if(department=="Health Department"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'health',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['health_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'health_member_count':dept_count1.toString(),

            });
      });
    });
  }
  else if(department=="Sewage And Sanitation"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'sewage',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['sewage_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'sewage_member_count':dept_count1.toString(),

            });
      });
    });
  }
  else if(department=="Other Department"){
    await firestore.collection('working_members').doc('$email').set({
      'name':name,
      'mobile_no':phone,
      'email':email,
      'password':password,
      'dept':'other',
      'area':current_email,
    }).whenComplete(() async{
      await firestore.collection('count').doc(current_email).get().then((value) {
        membercounter=value.data()['total_member'];
        dept_count=value.data()['other_member_count'];
      }).whenComplete(()async {
        membercounter1=int.parse(membercounter);
        dept_count1=int.parse(dept_count);
        membercounter1+=1;
        dept_count1+=1;
        await firestore.collection('count').doc(current_email).update(
            {
              'total_member':membercounter1.toString(),
              'other_member_count':dept_count1.toString(),

            });
      });
    });

  }
}
  
  
  
}