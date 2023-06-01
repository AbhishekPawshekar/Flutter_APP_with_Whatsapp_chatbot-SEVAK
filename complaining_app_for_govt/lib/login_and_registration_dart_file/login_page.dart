//@dart=2.9
import 'dart:ui';
import 'package:complaining_app_for_govt/all_screen_transition.dart';
import 'package:complaining_app_for_govt/read_data_form_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login_page extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _Login_pageState createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final email=TextEditingController();
  final password=TextEditingController();
  String authstatus="0";
  bool _passwordVisible=false;

  void showToast(String msg){
    Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,backgroundColor: Colors.orangeAccent,textColor: Colors.white);
  }
DateTime currentdatetimepress;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onwillpop,
      child: Scaffold(
       body:SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Image.asset('assets/login_page_vector_image.png',width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/3,),
                            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(alignment: Alignment.topLeft,
                                      child: Padding(padding: EdgeInsets.only(left: 20),
                                        child: Text('Login',style: TextStyle(fontSize: 45.0,fontWeight:FontWeight.bold,fontFamily: 'lobster'),
                                        ),
                                      ),
                                    ),
                                    Align(alignment: Alignment.topLeft,
                                      child: Padding(padding: EdgeInsets.only(left: 30,top: 20),
                                        child: Text('Please fill in the Credentials',style: TextStyle(fontSize: 10,color: Colors.grey),
                                        ),
                                      ),
                                    ),]),

                                      Padding(padding: EdgeInsets.only(left: 30,right: 10),
                                        child: TextField(keyboardType: TextInputType.emailAddress,textCapitalization: TextCapitalization.sentences,controller: email,
                                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orange,width: 1)),prefixIcon: const Icon(Icons.email_rounded,color: Colors.orangeAccent,),hintText: 'Email'),
                                          style: TextStyle(fontSize: 12.0,height: 0.5),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 30,right: 10),
                                        child: TextField(keyboardType: TextInputType.visiblePassword,textCapitalization: TextCapitalization.sentences,controller: password,obscureText: !_passwordVisible,
                                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide(color: Colors.orange,width: 1)),prefixIcon: const Icon(Icons.password_sharp,color: Colors.orangeAccent,),hintText: 'Password',
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                // Based on passwordVisible state choose the icon
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context).primaryColorDark,
                                              ),
                                              onPressed: () {
                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                setState(() {
                                                  _passwordVisible = !_passwordVisible;
                                                });
                                              },
                                            ),

                                          ),
                                          style: TextStyle(fontSize: 12.0,height: 0.5),
                                        ),
                                      ),
                                      Align(alignment: Alignment.topRight,
                                        child: SizedBox(
                                          width: 200,
                                          child: Padding(padding: EdgeInsets.fromLTRB(30,20.0,30.0,00.0),
                                              child: ElevatedButton(onPressed: () async {
                                                try {
                                                  await FirebaseAuth
                                                      .instance.signInWithEmailAndPassword(
                                                    email: email.text.toLowerCase().trim(),
                                                    password: password.text,
                                                  );
                                                  authstatus="success";
                                                } on FirebaseAuthException catch (e) {
                                                  switch (e.code) {
                                                    case "ERROR_USER_NOT_FOUND":
                                                    case "user-not-found":
                                                      showToast("No user found with this email.");
                                                      break;
                                                    case "ERROR_WRONG_PASSWORD":
                                                    case "wrong-password":
                                                      showToast( "Wrong email/password combination.");
                                                      break;
                                                    case "ERROR_USER_DISABLED":
                                                    case "user-disabled":
                                                      showToast( "User disabled.");
                                                      break;
                                                    case "ERROR_TOO_MANY_REQUESTS":
                                                    case "operation-not-allowed":
                                                      showToast( "Too many requests to log into this account.");
                                                      break;
                                                    case "ERROR_OPERATION_NOT_ALLOWED":
                                                    case "operation-not-allowed":
                                                      showToast( "Server error, please try again later.");
                                                      break;
                                                    case "ERROR_INVALID_EMAIL":
                                                    case "invalid-email":
                                                      showToast( "Email address is invalid.");
                                                      break;
                                                    default:
                                                      showToast( "Please Enter Email-id /Password");
                                                      break;
                                                  }
                                                }
                                                if(authstatus=="success"){
                                                  var screen=await get_user_dept_details_for_screen_to_load();
                                                  if(screen!=null){
                                                    Navigator.push(context, scale_transition (child:screen));
                                                  }
                                                }
                                              },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)))),
                                                child:  Text('Login',style: TextStyle(color: Colors.white,fontSize: 14.0,)),
                                              )
                                          ),
                                        ),
                                      ),
                                  ],),
                              ),
                            ),
                        ],),
          ),
        ),


      ),
    );
  }
  Future<bool> onwillpop()async {
    DateTime currenttime=DateTime.now();
    bool backpress=currentdatetimepress==null || currenttime.difference(currentdatetimepress)>Duration(seconds: 2);
    if(backpress){
      currentdatetimepress=currenttime;
      Fluttertoast.showToast(msg:'Double Click To Exit.!!',toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM,timeInSecForIosWeb: 1,backgroundColor: Colors.grey,textColor: Colors.white);

      return false;
    }
    return true;
  }
}
