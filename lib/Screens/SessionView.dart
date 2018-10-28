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