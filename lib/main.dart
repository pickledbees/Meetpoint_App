import 'package:flutter/material.dart';
import 'package:meetpoint/Screens/InitialiserView.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'dart:async';

void main() {
  print('App starting...');
  runApp(MeetPointApp());
  SessionManager_Client.poll();
  //runApp(Test());
  //runApp(Test2());
}

class MeetPointApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(11, 143, 160, 1.0),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        )
      ),
      title: 'MeetPoint',
      home: InitialiserView(InitialiserController(InitialiserModel())),
    );
  }
}