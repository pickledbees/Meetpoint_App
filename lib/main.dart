import 'package:flutter/material.dart';
import 'package:meetpoint/Screens/InitialiserView.dart';
import 'package:meetpoint/HttpUtil.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

void main() {
  print('App starting...');
  runApp(MeetPointApp());
  //runApp(Test());
  //runApp(Test2());
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
/*
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

class Test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'socket test';
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: title,
      home: SocketTest(
        channel : IOWebSocketChannel.connect('ws://echo.websocket.org'),
        title : title,
      ),
    );
  }
}
*/