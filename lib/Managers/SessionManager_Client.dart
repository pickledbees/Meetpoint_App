import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'Entities.dart';
import 'package:meetpoint/Screens/HomeView.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/Standards/LocationTypes.dart';
import 'package:meetpoint/Screens/SessionView.dart';
import 'package:meetpoint/HttpUtil.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'LocalUserInfoManager.dart';

Duration timelag = Duration(milliseconds: 10);
bool success = true;

class SessionManager_Client {
  //token to connect to server
  static final String _USERID = 'LOLIPUTZ';
  static IOWebSocketChannel channel;

  //currently loaded sessions
  static List<Session_Client> _sessions = [];
  static Session_Client _loadedSession;

  //read-only
  static List<Session_Client> get getSessions => _sessions;
  static Session_Client get getLoadedSession => _loadedSession;

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

  //fetch sessions from server
  static Future fetchSessions() async {
    var sessions_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.getSessions,
        'userId' : _USERID,
      },
      decode: false,//for debug
    );
    //TODO: parse map into List<Session_Client>

    print(sessions_mapForm);

    /* PRELIMINARY PARSER
    List<Session_Client> sessions = [];
    sessions_mapForm.forEach((key,session) {
      if (key == 'result') return;
      String sessionId = session['sessionId'];
      String title = session['title'];
      String prefLocationType = session['prefLocationType'];
      String U1N = session['U1N'];
      String U1T = session['U1T'];
      String U1A = session['U1A'];
      String U2N = session['U2N'];
      String U2T = session['U2T'];
      String U2A = session['U2A'];

      List<Meetpoint_Client> meetpoints = [];
      session['meetpoints'].forEach((key,meetpoint) {
        String routeImage = meetpoint['routeImage'];
        String name = meetpoint['name'];
        List<double> coordinates = [
          double.parse(meetpoint['coordinates']['lat']),
          double.parse(meetpoint['coordinates']['lon']),
        ];
        meetpoints.add(Meetpoint_Client(
          routeImage: routeImage,
          name: name,
          type: null,
          coordinates: coordinates,
        ));
      });

      Meetpoint_Client chosenMeetpoint = meetpoints[session['chosenMeetpoint']];

      sessions.add(Session_Client(
        sessionID: sessionId,
        title: title,
        prefLocationType: prefLocationType,
        chosenMeetpoint: chosenMeetpoint,
        meetpoints: meetpoints,
        users: [
          UserDetails_Client(
            name: U1N,
            prefTravelMode: U1T,
            prefStartCoords: Location_Client(
              name: U1A,
              type: null,
              address: U1A,
            ),
          ),
          UserDetails_Client(
            name: (U2N == '') ? null : U2N,
            prefTravelMode: (U2T == '') ? null : U2T,
            prefStartCoords: Location_Client(
              name: (U2A == '') ? null : U2A,
              type: null,
              address: (U2A == '') ? null : U2A,
            ),
          ),
        ],
      ));
    });
    */

    //TODO: REMOVE THIS CHUNK WHEN DONE
    _sessions = await Future.delayed(timelag, () => //change assignment
    success
        ? TestData.returned_sessions
        : throw 'error'
    );

    return;
  }//TODO: parse sessions (map) into List<Session_Client> and assign to '_sessions' (X)

  //completes to id if success, throws error if failed
  static Future createSession({@required String sessionTitle}) async {
    //creates session on server side
    Map createdSession_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : HttpUtil.methods.createSession,
        'userId' : _USERID,
        'sessionTitle' : sessionTitle,
      },
      decode: false,
      //TODO: parse map into Session_Client
    );

    print(createdSession_mapForm);

    /*PRELIMINARY PARSER
    Session_Client createdSession = Session_Client(
      sessionID: createdSession_mapForm['sessionId'],
      title: sessionTitle,
      chosenMeetpoint: null,
      meetpoints: <Meetpoint_Client>[],
      prefLocationType: LocationTypes.getList[0],
      users: [
        UserDetails_Client(
          name: createdSession_mapForm['U1N'],
          prefTravelMode: createdSession_mapForm['U1T'],
          prefStartCoords: Location_Client(
            name: createdSession_mapForm['U1A'],
            type: null,
            address: createdSession_mapForm['U1A'],
          ),
        ),
        UserDetails_Client(
          name: null,
          prefTravelMode: 'No Preference',
          prefStartCoords: Location_Client(
            name: null,
            type: null,
            address: null,
          ),
        ),
      ],
    );
    */

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
  }//TODO: parse session (map) into Session_Client assign to 'session' (X)

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
        'sessionId' : sessionId,
      },
      decode : false,
    );
    //TODO: parse map into Session_Client

    print(joinedSession_mapForm);

    /*PRELIMINARY PARSER
    String title = joinedSession_mapForm['title'];
    String prefLocationType = joinedSession_mapForm['prefLocationType'];
    String U1N = joinedSession_mapForm['U1N'];
    String U1T = joinedSession_mapForm['U1T'];
    String U1A = joinedSession_mapForm['U1A'];
    String U2N = joinedSession_mapForm['U2N'];
    String U2T = joinedSession_mapForm['U2T'];
    String U2A = joinedSession_mapForm['U2A'];

    List<Meetpoint_Client> meetpoints = [];
    joinedSession_mapForm['meetpoints'].forEach((key,meetpoint) {
      String routeImage = meetpoint['routeImage'];
      String name = meetpoint['name'];
      List<double> coordinates = [
        double.parse(meetpoint['coordinates']['lat']),
        double.parse(meetpoint['coordinates']['lon']),
      ];
      meetpoints.add(Meetpoint_Client(
        routeImage: routeImage,
        name: name,
        type: null,
        coordinates: coordinates,
      ));
    });

    Meetpoint_Client chosenMeetpoint = meetpoints[joinedSession_mapForm['chosenMeetpoint']];

    Session_Client session = Session_Client(
      sessionID: sessionId,
      title: title,
      prefLocationType: prefLocationType,
      chosenMeetpoint: chosenMeetpoint,
      meetpoints: meetpoints,
      users: [
        UserDetails_Client(
          name: U1N,
          prefTravelMode: U1T,
          prefStartCoords: Location_Client(
            name: U1A,
            type: null,
            address: U1A,
          ),
        ),
        UserDetails_Client(
          name: U2N,
          prefTravelMode: U2T,
          prefStartCoords: Location_Client(
            name: U2A,
            type: null,
            address: U2A,
          ),
        ),
      ],
    );
    */

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
  }//TODO: parse session (map) into Session_Client assign to 'session' (X)

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
      decode : false,
    );//TODO: parse map into boolean

    print(result_map);

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
      decode: false,
    );

    print(result_map);

    //TODO: remove chunk when done
    return await Future.delayed(timelag, () =>
    success
        ? success
        : throw 'error'
    );
  }//TODO: to complete

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
      decode: false,
    );//TODO: parse map into boolean

    print(ok_map);

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

    /*PRELIMINARY PARSER
    List<Meetpoint_Client> meetpoints = [];
    session['meetpoints'].forEach((key,meetpoint) {
      if (key == 'result') return;
      String routeImage = meetpoint['routeImage'];
      String name = meetpoint['name'];
      List<double> coordinates = [
        double.parse(meetpoint['coordinates']['lat']),
        double.parse(meetpoint['coordinates']['lon']),
      ];
      meetpoints.add(Meetpoint_Client(
        routeImage: routeImage,
        name: name,
        type: null,
        coordinates: coordinates,
      ));
    });
    */

    return true;
  }//TODO: parse result (map) into meetpoint list and assign to meetpoints (X)

  static bool getNew = true;
  static var oldTimestamp;

  //to handle unprompted incoming data in the background
  static Widget streamHandler(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      //extract data
      Map body = json.decode(snapshot.data);

      //process if it is new snapshot
      if (body['timestamp'] != oldTimestamp) {
        //update timestamp
        oldTimestamp = body['timestamp'];
        print(snapshot.data);

        //parse request
        switch (body['method']) {
          case 'editSession': //up to zach to handle
            updateSession(
              sessionId: body['sessionId'],
              field: body['field'],
              value: body['value'],
            );
            break;
        }
      }
    }
    //just to fill the space
    return Text('');
  } //TODO: possibly make it handle other requests

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
    /*
    //remote updates
    if (HomeView.widget != null) { //check if view has been initialised
      if (HomeView.widget.controller.isMounted) { //check if view is in view
        HomeView.refresh = true;
        HomeView.widget.build(HomeView.widget.viewContext);
      }
    }
    */
    /*
    if (SessionView.widget != null) { //check if view has been initialised
      if (SessionView.widget.controller.isMounted) { //check if view is in view
        SessionView.widget.build(SessionView.viewContext);
      }
    }
    */
    HomeView.refresh = true;
  }//TODO: can update local memory, but not the UI, maybe try to fix---------------------------------------------------------------------
}

abstract class Field {
  static const String preferredLocationType = 'LT';
  static const String chosenMeetpoint = 'CM';
  static const String user1Address = 'U1A';
  static const String user2Address = 'U2A';
  static const String user1PreferredTravelMode = 'U1T';
  static const String user2PreferredTravelMode = 'U2T';
}

abstract class Methods {
  static const String saveUser = 'updateUser';
  static const getSessions = 'getSessions';
  static const createSession = 'createSession';
  static const joinSession = 'joinSession';
  static const deleteSession = 'deleteSession';
  static const editSession = 'editSession';
  static const calculate = 'calculate';
}