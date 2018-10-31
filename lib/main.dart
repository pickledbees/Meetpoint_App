import 'package:flutter/material.dart';
import 'package:meetpoint/Screens/HomeView.dart';
import 'package:meetpoint/Screens/FirstStartView.dart';
import 'package:meetpoint/Screens/InitialiserView.dart';
import 'package:http/http.dart';

void main() {
  print('App starting...');
  runApp(HttpTest());
}

class MeetPointApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      title: 'MeetPoint',
      home: InitialiserView(InitialiserController(InitialiserModel())),
    );
  }
}

class HttpTest extends StatefulWidget {
  @override
  _HttpTestState createState() => _HttpTestState();
}

class _HttpTestState extends State<StatefulWidget> {
  String info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(info),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendRequest,
      ),
    );
  }

  sendRequest() {
  }
}