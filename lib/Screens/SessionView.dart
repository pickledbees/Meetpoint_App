import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'MoreSessionInfoUI.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';

class SessionView extends View<SessionController> {
  SessionView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.model.body,
    );
  }
}

class SessionController extends Controller<SessionModel> {
  SessionController(m) : super(model: m);
}

class SessionModel extends Model {
  SessionModel(String sessionId) {
    LocalSessionManager.loadSession(sessionId: sessionId);
    session = LocalSessionManager.openSession;
  }

  static Session session;

  Widget body = Center(
    child: Text(
      session.sessionID,
    ),
  );

}




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