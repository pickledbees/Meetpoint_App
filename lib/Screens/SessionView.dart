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
      appBar: AppBar(title: Text(controller.model.session.title),),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Others can join this meeting with the following ID'),
            ),
            Container(
              child: Text(controller.model.session.sessionID),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.model.session.users[0].name),
                  Text(controller.model.session.users[1].name),
                ],
              ),
            ),
            Container(
              height: 100.0,
              child: PageView(
                children: <Widget>[
                  Text('1'),
                  Text('2'),
                  Text('3'),
                ],
              ),
            ),
            Container(
              child: Text('buttons'),
            )
            //description
            //members
            //maps display
            //parameters widget
          ],
        ),
      ),
    );
  }
}

class SessionController extends Controller<SessionModel> {
  SessionController(m) : super(model: m);
}

class SessionModel extends Model {

  SessionModel(String sessionId) {
    //load session
    LocalSessionManager.loadSession(sessionId: sessionId);
    session = LocalSessionManager.openSession;
  }

  Session session;
  String placeholder;

}