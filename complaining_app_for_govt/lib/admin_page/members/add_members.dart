//@dart=2.9
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../write_data_to_firestore.dart';
class add_members extends StatefulWidget {
  const add_members({Key key}) : super(key: key);

  @override
  _add_membersState createState() => _add_membersState();
}

class _add_membersState extends State<add_members> {
  final name_of_member=TextEditingController();
  final phone_no_of_members=TextEditingController();
  final password =TextEditingController();
  final email=TextEditingController();
  final repassword=TextEditingController();
  var department='Road Department';
  String status_of_auth;
  bool checkvalue=false;
  final formkey=GlobalKey<FormState>();
  void showToast(String msg){
    Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,backgroundColor: Colors.orangeAccent,textColor: Colors.white);
  }
  var adminemail,passwordadmin,logo_image;

  dynamic logo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlogodata();
  }
  Future<void> getlogodata()async{
    await firestore.collection('admin').doc(current_email).get().then((value) {
      setState(() {
        logo_image=value.data()['logo'];
        passwordadmin=value.data()['password'];
      });
      adminemail=current_email;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.orangeAccent,), onPressed: () {Navigator.pop(context, false) ; },),backgroundColor: Colors.transparent,centerTitle: true,title: Text('Add Members',style: TextStyle(color: Colors.orangeAccent,),),),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height-100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget> [
                Padding(padding: EdgeInsets.only(left: 10.0),
                  child: DropdownButton<String>(
                    value: department,
                    elevation: 16,
                    style: const TextStyle(color: Colors.cyan),
                    underline: Container(
                      height: 2,
                      color: Colors.orangeAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        department = newValue;
                      });
                    },
                    items: <String>['Road Department','Bus Department','Electric Department','Health Department','Sewage And Sanitation Department','Other Department']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          child: Card(elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                              child: (logo_image!=null)?Image.network('$logo_image'):
                              Text("logo"),


                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(10, 30, 10,0.0),
                                child:Container(
                                  child: TextFormField(keyboardType: TextInputType.name,textCapitalization: TextCapitalization.sentences,controller: name_of_member,
                                    validator: (val)=>val.isNotEmpty?null:"Plz Enter name..!!",
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded,color: Colors.orangeAccent,),hintText: 'Full Name Of Members'),
                                    style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                                child: Container(
                                  child: TextFormField(keyboardType: TextInputType.emailAddress,textCapitalization: TextCapitalization.sentences,controller:email,
                                    validator: (String value){
                                      if(value.isEmpty)
                                      {
                                        return 'Please Enter Email.!!';
                                      }
                                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                        return 'Please Enter valid Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.email_rounded,color: Colors.orangeAccent,),hintText: 'Enter Email of Member:'),
                                    style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                                child: Container(
                                  child: TextFormField(keyboardType: TextInputType.phone,textCapitalization: TextCapitalization.sentences,controller:phone_no_of_members,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (val){
                                      if(val.isEmpty){
                                        return "Plz Enter Mobile No.!!";
                                      }
                                      if(val.trim().length!=10){
                                        return "Enter Valid Mobile NO.!!";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.phone,color: Colors.orangeAccent,),hintText: 'Phone No'),maxLength: 10,
                                    style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                                child: Container(
                                  child: TextFormField(keyboardType: TextInputType.visiblePassword,textCapitalization: TextCapitalization.sentences,controller: password,
                                    validator: (val){
                                      if(val.isEmpty)
                                      {return 'Plz Enter Password';}
                                      if(val.length<4){
                                        return 'Password Length Must Greater Then 4.!!';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.password_sharp,color: Colors.orangeAccent,),hintText: 'Password'),
                                    style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0.0),
                                child: Container(
                                  child: TextFormField(keyboardType: TextInputType.visiblePassword,textCapitalization: TextCapitalization.sentences,controller: repassword,
                                    validator: (val){
                                      if(val.isEmpty)
                                      {return 'Plz Enter Re-Password';}
                                      if(password.text!=repassword.text){
                                        return 'Password Does Not Match.!!';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orangeAccent,width: 1)),prefixIcon: const Icon(Icons.password_sharp,color: Colors.orangeAccent,),hintText: 'Re-Password'),
                                    style: TextStyle(color: Colors.orangeAccent,fontSize: 12.0,height: 0.5),
                                  ),
                                ),
                              ),


                              Padding(padding: EdgeInsets.only(top:10,left:10),
                                child: CheckboxListTile(
                                  title: Text("Appoint As Head Of Selected Department",style: TextStyle(color: Colors.amber,fontSize: 12),),
                                  value: checkvalue,
                                  selected: false,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkvalue = newValue;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                ),
                              ),
                            ],),
                        ),
                      ),
                    ],),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(padding: EdgeInsets.fromLTRB(30,20.0,30.0,00.0),
                      child: ElevatedButton(onPressed: () async { if(formkey.currentState.validate())
                      {
                        try{
                          //register member to firebase auth
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: email.text.toLowerCase().trim(), password: password.text);
                          status_of_auth="Success";
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "ERROR_EMAIL_ALREADY_IN_USE":
                            case "account-exists-with-different-credential":
                            case "email-already-in-use":
                              showToast("Email already used.");
                              break;
                            case "ERROR_TOO_MANY_REQUESTS":
                            case "operation-not-allowed":
                            showToast("Too many requests to log into this account.");
                              break;
                            case "ERROR_OPERATION_NOT_ALLOWED":
                            case "operation-not-allowed":
                            showToast("Server error, please try again later.");
                              break;
                            case "ERROR_INVALID_EMAIL":
                            case "invalid-email":
                                showToast("Email address is invalid.");
                              break;
                            default:
                                showToast( "Please Enter Email-id/ Password.");
                              break;
                          }
                        } catch (e) {
                          showToast(e.toString());
                        }
                        if(status_of_auth!="Failed"){
                          // login again admin because due to createuserwithemialandpassword  that user logged in
                          await firebaseAuth.signInWithEmailAndPassword(email: adminemail, password: passwordadmin);
                          await add_members_to_database(checkvalue,department,name_of_member.text,phone_no_of_members.text,email.text.toLowerCase().trim(),password.text);
                          showToast('SuccessFully Registered.!!');
                        }
                        return;
                      }else{
                        print("UnSuccessfull");
                      }
                      },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)))),
                        child:  Text('Submit',style: TextStyle(color: Colors.white,fontSize: 14.0,)),
                      )
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
