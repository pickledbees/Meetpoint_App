import 'package:flutter/foundation.dart';
import 'dart:async';
import 'Entities.dart';
import 'package:meetpoint/Screens/HomeView.dart';
import 'package:meetpoint/Screens/SessionView.dart';
import 'package:meetpoint/HttpUtil.dart';

Duration timelag = Duration(milliseconds: 10);
bool success = true;

class SessionManager_Client {
  //token to connect to server
  static final String _USERID = 'LOLIPUTZ';

  //currently loaded sessions
  static List<Session_Client> _sessions = [];
  static Session_Client _loadedSession;

  //read-only
  static List<Session_Client> get getSessions => _sessions;
  static Session_Client get getLoadedSession => _loadedSession;

  //fetch sessions from server
  static Future fetchSessions() async {

    Map sessions_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.getSessions,
        'userId' : _USERID,
      },
    );
    //TODO: parse map into List<Session_Client>

    //TODO: REMOVE THIS CHUNK WHEN DONE
    _sessions = await Future.delayed(timelag, () => //change assignment
    success
        ? TestData.returned_sessions
        : throw 'error'
    );

    return;
  }//TODO: parse sessions (map) into List<Session_Client> and assign to '_sessions'

  //returns session index based on session id, returns -1 if not found
  static int _findSession(String sessionId) {
    print('finding $sessionId');
    int index;
    //search through sessions list
    for (Session_Client session in _sessions) {
      if (session.sessionID == sessionId) {
        index = _sessions.indexOf(session);
        break;
      }
    }
    print('found $sessionId at index $index');
    return index ?? -1;
  }

  //completes to id if success, throws error if failed
  static Future createSession({@required String sessionTitle}) async {
    //creates session on server side
    Map createdSession_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.createSession,
        'userId' : _USERID,
        'sessionTitle' : sessionTitle
      },
      //TODO: parse map into Session_Client
    );

    //TODO: remove chunk when done
    Session_Client session = //change assignment
    await Future.delayed(timelag, () =>
    success
        ? TestData.created_session(sessionTitle)
        : throw 'error'
    );

    //add session on local side
    _sessions.insert(0,session);
    HomeView.refresh = true;
    return session.sessionID;
  }//TODO: parse session (map) into Session_Client assign to 'session'

  //completes to id if success, throws error if failed
  static Future joinSession({@required String sessionId}) async {
    //check if session is already inside local memory
    if (_findSession(sessionId) != -1) return null;
    //requests to join / add session on server side
    Map joinedSession_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.joinSession,
        'userId' : _USERID,
        'sessionId' : sessionId
      },
    );
    //TODO: parse map into Session_Client

    //TODO: remove chunk when done
    Session_Client session = //change assignment
    await Future.delayed(timelag, () =>
    success
        ? TestData.joined_session(sessionId)
        : throw 'error'
    );

    //add session on local side
    _sessions.insert(0,session);
    HomeView.refresh = true;
    return session.sessionID;
  }//TODO: parse session (map) into Session_Client assign to 'session'

  //completes to boolean true if success, throws error if failed
  static Future deleteSession({@required String sessionId}) async {
    //delete session on server
    Map result_map = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.deleteSession,
        'userId' : _USERID,
        'sessionId' : sessionId
      },
    );//TODO: parse map into boolean

    //TODO: remove chunk when done
    await Future.delayed(timelag, () =>
    success
        ? _sessions.removeAt(_findSession(sessionId))
        : throw 'error'
    );

    //delete session on local
    HomeView.refresh = true;
    return true;
  }//TODO: parse ok (map) into boolean and delete based on success or not

  //loads session to be the currently open session
  static Session_Client loadSession({@required String sessionId}) {
    print('opening session $sessionId');
    if (_findSession(sessionId) == -1) throw 'no such session';
    _loadedSession = _sessions[_findSession(sessionId)];
    print('session ${_loadedSession.sessionID} opened');
    return _loadedSession;
  }

  //completes to boolean true if success, throws error if failed
  static Future requestSessionEdit({
    @required String sessionId,
    @required String field,
    @required String value,
  }) async {
    //send edit request
    Map result_map = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.editSession,
        'userId' : _USERID,
        'sessionId' : sessionId,
        'field' : field,
        'value' : value,
      },
    );

    //TODO: remove chunk when done
    return await Future.delayed(timelag, () =>
    success
        ? success
        : throw 'error'
    );
  }//TODO: to complete

  //local update
  static updateSession({
    @required String sessionId,
    @required String field,
    @required String value,
  }) {
    if (_findSession(sessionId) == -1 ) return; //if server sends invalid ID
    Session_Client session = _sessions[_findSession(sessionId)];
    //update local stuff
    switch (field) {
      case Field.preferredLocationType:
        session.prefLocationType = value;
        print(field);
        break;
      case Field.chosenMeetpoint:
        session.chosenMeetpoint = session.meetpoints[int.parse(value)];
        print(field);
        break;
      case Field.user1Address:
        session.users[0].prefStartCoords.address = value;
        print(field);
        break;
      case Field.user2Address:
        session.users[1].prefStartCoords.address = value;
        print(field);
        break;
      case Field.user1PreferredTravelMode:
        session.users[0].prefTravelMode = value;
        print(field);
        break;
      case Field.user2PreferredTravelMode:
        session.users[1].prefTravelMode = value;
        print(field);
        break;
      default:
        print(field);
    }

    //remote updates
    if (HomeView.widget.controller.isMounted) {
      HomeView.refresh = true;
      HomeView.widget.build(HomeView.widget.viewContext);
    }

    if (SessionView.widget.controller.isMounted) {
      SessionView.widget.build(SessionView.viewContext);
    }

    HomeView.refresh = true;
  }//TODO: may be a bit buggy, try to fix---------------------------------------------------------------------

  static Future saveUser(UserDetails_Client user) async {
    //send save request
    Map ok_map = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.saveUser,
        'userId' : _USERID,
        'name' : user.name,
        'defaultTravelMode' : user.prefTravelMode,
        'defaultStartName' : user.prefStartCoords.name,
        'defaultStartAddress' : user.prefStartCoords.address,
      },
    );//TODO: parse map into boolean

    return true;
  }//TODO: parse ok (map) into boolean and save user based on success or not

  static Future calcMeetpoint() async {
    //calculate meetpoint
    var meetpoints_mapform = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.calculate,
        'userId' : _USERID,
        'sessionId' : _loadedSession.sessionID,
      },
      decode: false, //FOR DEBUGGING
    );
    print(meetpoints_mapform);// FOR DEBUGGING
    return true;
  }//TODO: parse result (map) into meetpoint list and assign to meetpoints
}

abstract class Field {
  static const String preferredLocationType = 'LT';
  static const String chosenMeetpoint = 'CM';
  static const String user1Address = 'U1A';
  static const String user2Address = 'U2A';
  static const String user1PreferredTravelMode = 'U1T';
  static const String user2PreferredTravelMode = 'U2T';
}