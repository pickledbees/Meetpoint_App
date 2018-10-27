import 'package:flutter/material.dart';
import 'MoreSessionInfoUI.dart';
import 'package:meetpoint/Models/Session.dart';

class SessionViewUI extends StatelessWidget {

  final String sessionId;
  static Session session;

  SessionViewUI(this.sessionId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(session.title),),
      body: Center(
        child: Column(
          children: [
            //SessionIDWidget(),
            //MembersRowWidget(),
            //MapDisplayWidget(),
            ParamFormWidget(),
          ],
        ),
      ),
    );
  }

  void loadSession() {
    //request session from server
  }
}

class MapDisplayWidget extends StatefulWidget {
  //use pageView
  @override
  _MapDisplayWidget createState() => _MapDisplayWidget();
}

class _MapDisplayWidget extends State<MapDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        scrollDirection:Axis.horizontal,
        children: <Widget>[
          //mapwidget1()
          //mapwidget1()
          //mapwidget1()
          //mapwidget1()
        ],
      ),
    );
  }
}

class ParamFormWidget extends StatefulWidget {
  @override
  _ParamFormWidgetState createState() => _ParamFormWidgetState();
}

class _ParamFormWidgetState extends State<ParamFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //preferred location widget
        //user1 widget
        //user2 widget
      ],
    );
  }
}