import 'package:flutter/foundation.dart';
import 'dart:async';
import 'Entities.dart';

Duration timelag = Duration(seconds: 1);
bool success = true;

class LocalSessionManager {
  //token to connect to server
  static final String _TOKEN = 'LOLIPUTZ';

  static List<Session> _sessions;// = TestData.returned_sessions;
  static Session _openSession;

  //read-only
  static List<Session> get sessions => _sessions;
  static Session get openSession => _openSession;


  //fetch sessions from server
  static Future fetchSessions() async {
    _sessions = await Future.delayed(timelag, () =>
    success
        ? TestData.returned_sessions
        : throw 'error'
    );
    return;
  }

  //returns session index based on session id
  static int _findSession(String sessionId) {
    int index;
    //search through sessions list
    for (Session session in _sessions) {
      if (session.sessionID == sessionId) index = sessions.indexOf(session);
      break;
    }
    return index;
  }

  //completes to id if success, throws error if failed
  static Future createSession({@required String sessionTitle}) async {
    //**replace with socket request**
    //creates session on server side + add session on local side
    Session session =
    await Future.delayed(timelag, () =>
    success
        ? TestData.created_session(sessionTitle)
        : throw 'error'
    );
    _sessions.add(session);
    return session.sessionID;
  }

  //completes to id if success, throws error if failed
  static Future addSession({@required String sessionId}) async {
    //**replace with socket request**
    //adds session on server side + add session on local side
    Session session =
    await Future.delayed(timelag, () =>
    success
        ? TestData.joined_session(sessionId)
        : throw 'error'
    );
    _sessions.add(session);
    return session.sessionID;
  }

  //completes to boolean true if success, throws error if failed
  static Future deleteSession({@required String sessionId}) async {
    //**replace with socket request**
    return await Future.delayed(timelag, () =>
    success
        ? _sessions.removeAt(_findSession(sessionId))
        : throw 'error'
    );
  }

  //loads session to be the currently open session
  static void loadSession({@required String sessionId}) {
    //**replace with socket request**
    _openSession = _sessions[_findSession(sessionId)];
  }

  //completes to boolean true if success, throws error if failed
  static Future requestSessionEdit({
    @required String sessionId,
    @required String editCallBack,
    List<Map<String,String>> params
  }) async {
    //**replace with socket request**
    await Future.delayed(timelag, () =>
    success
        ? success
        : throw 'error'
    );
    //edit local copy if success
    int index = _findSession(sessionId);
    //**editMethod parser**
    //**edit appropriate member in _openSession**
  }
}

class Listener {
  //listens for updates
}