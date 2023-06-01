//@dart=2.9
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class fade_transition extends PageRouteBuilder {
  final Widget child;

  fade_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(milliseconds: 600),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
      FadeTransition(opacity: animation,child:child,);
}

class scale_transition extends PageRouteBuilder {
  final Widget child;

  scale_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(milliseconds: 600),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
  ScaleTransition(scale:animation,child: child,);
}

class bottom_to_up_transition extends PageRouteBuilder {
  final Widget child;

  bottom_to_up_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(milliseconds: 600),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
      SlideTransition(position: Tween<Offset>(
        begin: Offset(0,1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn),).animate(animation),child: child,);
}

class right_to_left_transition extends PageRouteBuilder {
  final Widget child;

  right_to_left_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(milliseconds: 600),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
      SlideTransition(position: Tween<Offset>(
        begin: Offset(1,0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease),).animate(animation),child: child,);

}

class left_to_right_transition extends PageRouteBuilder {
  final Widget child;

  left_to_right_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(milliseconds: 600),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
      SlideTransition(position: Tween<Offset>(
        begin: Offset(-1,0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease),).animate(animation),child: child,);

}

class top_to_bottom_transition extends PageRouteBuilder {
  final Widget child;

  top_to_bottom_transition({ this.child}):super(barrierDismissible: false,barrierColor: Colors.white,transitionDuration:Duration(milliseconds: 600),reverseTransitionDuration: Duration(seconds: 1),pageBuilder:(context,animation,secondaryAnimation)=>child, );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)=>
      SlideTransition(position: Tween<Offset>(
        begin: Offset(0,-1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease),).animate(animation),child: child,);
}

