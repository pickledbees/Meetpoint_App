import 'package:flutter/material.dart';
import 'package:meetpoint/Screens/HomeView.dart';
import 'package:meetpoint/Screens/FirstStartView.dart';
import 'package:meetpoint/Screens/InitialiserView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meetpoint/HttpUtil.dart';
import 'dart:async';

void main() {
  print('App starting...');
  runApp(MeetPointApp());
  //runApp(Test());
}

class MeetPointApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan,),
      title: 'MeetPoint',
      home: InitialiserView(InitialiserController(InitialiserModel())),
    );
  }
}


//For testing porpoises ----------------------------------------------------------------------


class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'test',
      home: HttpTest(),
    );
  }
}

class HttpTest extends StatefulWidget {
  @override
  _HttpTestState createState() => _HttpTestState();
}

class _HttpTestState extends State<StatefulWidget> {
  String info = 'default';
  TextEditingController c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(info),
            TextField(
              controller: c,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Post'),
            onPressed: sendPost,
          ),
          RaisedButton(
            child: Text('Get'),
            onPressed: sendGet,
          )
        ],
      ),
    );
  }

  sendPost() {
    setState(() => info = 'posting...');
    HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'text' : c.text,
      },
    ).then((json) {
      setState(() => info = json['text']);
      print(json['text']);
    }).catchError((error) {
      print(error);
    });

  }

  sendGet() {
    setState(() => info = 'getting...');
    HttpUtil.getData(
      url: HttpUtil.serverURL,
      decode: false,
    ).then((jsonStr) {
      setState(() => info = jsonStr);
      print(jsonStr);
    }).catchError((error) {
      print(error);
    });
  }

}