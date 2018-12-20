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

///Class that manages the information of the local user
///Extended by [Meetpoint_Client]
///@author Lim Han Quan
///@version 2.3
///@since 2018-11-13
class SessionManager_Client {

  ///Unique token to connect to server.
  static String _USERID = null;

  ///Currently loaded sessions.
  static List<Session_Client> _sessions = [];

  //Current session loaded in view of the user.
  static Session_Client _loadedSession;

  static List<Session_Client> get getSessions => _sessions;
  static Session_Client get getLoadedSession => _loadedSession;
  static String get userId => _USERID;
  static set userId(String userId) => _USERID = userId;

  ///Returns index in [_sessions] list based on session id.
  static int _findSession(String sessionId) {
    //print('finding $sessionId');
    int index;
    //search through sessions list
    for (Session_Client session in _sessions) {
      if (session.sessionID == sessionId) {
        index = _sessions.indexOf(session);
        break;
      }
    }
    //print('found $sessionId at index $index');
    return index ?? -1;
  }

  ///Loads session to be the currently open session.
  static Session_Client loadSession({@required String sessionId}) {
    //print('opening session $sessionId');
    if (_findSession(sessionId) == -1) throw 'no such session';
    _loadedSession = _sessions[_findSession(sessionId)];
    //print('session ${_loadedSession.sessionID} opened');
    return _loadedSession;
  }

  ///Fetches sessions from server and loads them into [_sessions] list.
  static Future fetchSessions() async {

    Map sessions_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.getSessions,
        'userId' : _USERID,
      },
      decode: true,//for debug
    );

    if (sessions_mapForm['result'] == 'O') {

      List<Session_Client> sessions = [];
      if (sessions_mapForm['sessions'].length > 0) {
        for (var sessionObj in sessions_mapForm['sessions']) {
          //store meetpoints list
          List<Meetpoint_Client> meetpoints = [];
          //check for presence of meetpoints
          if (sessionObj['meetpoints'].length > 0) {
            for (int i = 0; i < sessionObj['meetpoints'].length; i++) {
              meetpoints.add(
                  Meetpoint_Client(
                    routeImage: sessionObj['meetpoints'][i]['routeImage'],
                    routeImage2: sessionObj['meetpoints'][i]['routeImage2'],
                    name: sessionObj['meetpoints'][i]['name'],
                    type: null,

                    coordinates: <double>[
                      double.parse(sessionObj['meetpoints'][i]['coordinates']['lat']),
                      double.parse(sessionObj['meetpoints'][i]['coordinates']['lon']),
                    ],

                  )
              );
            }
          }

          Session_Client session = Session_Client(
            sessionID: sessionObj['sessionId'],
            title: sessionObj['title'],
            chosenMeetpoint: meetpoints.length == 0
                ? null
                : meetpoints[int.parse(sessionObj['chosenMeetpoint'])],
            meetpoints: meetpoints,
            prefLocationType: LocationTypes.inList(sessionObj['prefLocationType'])
                ? sessionObj['prefLocationType']
                : LocationTypes.getList[0],
            users: [
              UserDetails_Client(
                name: sessionObj['U1N'],
                prefTravelMode: TravelModes.inList(sessionObj['U1T'])
                    ? sessionObj['U1T']
                    : TravelModes.getList[0],
                prefStartCoords: Location_Client(
                  name: sessionObj['U1A'],
                  type: '',
                  address: sessionObj['U1A'],
                ),
              ),
              UserDetails_Client(
                name: sessionObj['U2N'],
                prefTravelMode: TravelModes.inList(sessionObj['U2T'])
                    ? sessionObj['U2T']
                    : TravelModes.getList[0],
                prefStartCoords: Location_Client(
                  name: sessionObj['U2A'],
                  type: '',
                  address: sessionObj['U2A'],
                ),
              ),
            ],
          );
          sessions.add(session);
        }

        _sessions = sessions;
        print('sessions parsed');
        return;
      } else {
        _sessions = [];
        return;
      }
    } else {
      print('ds');
      throw 'Failed to fetch your sessions.\n\nYou might not be connected to the Internet.';
    }
  }

  ///Creates a session on the server side and loads it into [_loadedSession].
  static Future createSession({@required String sessionTitle}) async {
    //creates session on server side
    var createdSession_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.createSession,
        'userId' : _USERID,
        'sessionTitle' : sessionTitle,
      },
      decode: true,
      //TODO: parse map into Session_Client
    );

    if (createdSession_mapForm['result'] == 'O') {
      Session_Client session = Session_Client(
        sessionID: createdSession_mapForm['sessionId'].toString(),
        title: sessionTitle,
        chosenMeetpoint: null,
        meetpoints: <Meetpoint_Client>[],
        prefLocationType: LocationTypes.getList[0],
        users: [
          UserDetails_Client(
            name: createdSession_mapForm['U1N'],
            prefTravelMode: TravelModes.inList(createdSession_mapForm['U1T'])
                ? createdSession_mapForm['U1T']
                : TravelModes.getList[0],
            prefStartCoords: Location_Client(
              name: createdSession_mapForm['U1A'],
              type: '',
              address: createdSession_mapForm['U1A'],
            ),
          ),
          UserDetails_Client(
            name: null,
            prefTravelMode: TravelModes.getList[0],
            prefStartCoords: Location_Client(
              name: null,
              type: null,
              address: null,
            ),
          ),
        ],
      );

      //add session on local side
      _sessions.insert(0,session);
      HomeView.refresh = true;
      return session.sessionID;

    } else {
      throw 'Server failed to create session.';
    }

  }

  ///Joins a session on the server side and loads it into [_loadedSession].
  static Future joinSession({@required String sessionId}) async {
    //check if session is already inside local memory
    if (_findSession(sessionId) != -1) return null;
    //requests to join / add session on server side
    var joinedSession_mapForm = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.joinSession,
        'userId' : _USERID,
        'sessionId' : sessionId,
      },
    );

    if (joinedSession_mapForm['result'] == 'O') {
      //store meetpoints list
      List<Meetpoint_Client> meetpoints = [];
      //check for presence of meetpoints
      if (joinedSession_mapForm['meetpoints'].length > 0) {
        for (int i = 0; i < joinedSession_mapForm['meetpoints'].length; i++) {
          meetpoints.add(
              Meetpoint_Client(
                routeImage: joinedSession_mapForm['meetpoints'][i]['routeImage'],
                routeImage2: joinedSession_mapForm['meetpoints'][i]['routeImage2'],
                name: joinedSession_mapForm['meetpoints'][i]['name'],
                type: null,
                coordinates: <double>[
                  double.parse(joinedSession_mapForm['meetpoints'][i]['coordinates']['lat']),
                  double.parse(joinedSession_mapForm['meetpoints'][i]['coordinates']['lon']),
                ],
              )
          );
        }
      }


      Session_Client session = Session_Client(
        sessionID: joinedSession_mapForm['sessionId'],
        title: joinedSession_mapForm['title'],
        chosenMeetpoint: meetpoints.length == 0
            ? null
            : meetpoints[int.parse(joinedSession_mapForm['chosenMeetpoint'])],
        meetpoints: meetpoints,
        prefLocationType: LocationTypes.inList(joinedSession_mapForm['prefLocationType'])
            ? joinedSession_mapForm['prefLocationType']
            : LocationTypes.getList[0],
        users: [
          UserDetails_Client(
            name: joinedSession_mapForm['U1N'],
            prefTravelMode: TravelModes.inList(joinedSession_mapForm['U1T'])
                ? joinedSession_mapForm['U1T']
                : TravelModes.getList[0],
            prefStartCoords: Location_Client(
              name: joinedSession_mapForm['U1A'],
              type: '',
              address: joinedSession_mapForm['U1A'],
            ),
          ),
          UserDetails_Client(
            name: joinedSession_mapForm['U2N'],
            prefTravelMode: TravelModes.inList(joinedSession_mapForm['U2T'])
                ? joinedSession_mapForm['U2T']
                : TravelModes.getList[0],
            prefStartCoords: Location_Client(
              name: joinedSession_mapForm['U2A'],
              type: '',
              address: joinedSession_mapForm['U2A'],
            ),
          ),
        ],
      );

      //add session on local side
      _sessions.insert(0,session);
      HomeView.refresh = true;
      return session.sessionID;

    } else {
      throw 'Session may be full or does not exist.';
    }

  }

  ///Deletes a session on the server side and removes it from [_sessions] list.
  static Future deleteSession({@required String sessionId}) async {
    //delete session on server
    var response = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.deleteSession,
        'userId' : _USERID,
        'sessionId' : sessionId
      },
      decode : true,
    );

    if (response['result'] == 'O') {
      //local delete
      _sessions.removeAt(_findSession(sessionId));
      HomeView.refresh = true;
      return true;
    } else {
      print('could not delete');
      return false;
    }
  }

  ///Requests from the server to save the user.
  static Future saveUser(UserDetails_Client user) async {
    print('saving user...');
    //send save request

    var response = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.saveUser,
        'userId' : _USERID,
        'name' : user.name,
        'defaultTravelMode' : user.prefTravelMode,
        'defaultStartName' : user.prefStartCoords.name,
        'defaultStartAddress' : user.prefStartCoords.address,
      },
    );

    bool ok = response['result'] == 'O';
    if (ok) _USERID = response['userId'];
    print('User id is $_USERID');
    return ok;
  }

  ///Requests a calculation of the currently loaded session from the server.
  static Future calcMeetpoint() async {
    //calculate meetpoint
    var meetpoints_mapform = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.calculate,
        'userId' : _USERID,
        'sessionId' : _loadedSession.sessionID,
      },
      decode: true, //FOR DEBUGGING
    );

    print('received meetpoints');
    print(meetpoints_mapform['result']);
    if (meetpoints_mapform['result'] == 'X') return false;
    if (meetpoints_mapform['result'] == 'O' && meetpoints_mapform['meetpoints'].length > 0) {
      print('parsng meetpoints json');
      //store meetpoints list
      List<Meetpoint_Client> meetpoints = [];
      for (int i = 0; i < meetpoints_mapform['meetpoints'].length; i++) {
        meetpoints.add(
            Meetpoint_Client(
              routeImage: meetpoints_mapform['meetpoints'][i]['routeImage'],
              routeImage2: meetpoints_mapform['meetpoints'][i]['routeImage2'],
              name: meetpoints_mapform['meetpoints'][i]['name'],
              type: null,
              coordinates: <double>[
                double.parse(meetpoints_mapform['meetpoints'][i]['coordinates']['lat']),
                double.parse(meetpoints_mapform['meetpoints'][i]['coordinates']['lon']),
              ],
            )
        );
      }

      //store into session
      _loadedSession.meetpoints = meetpoints;
      _loadedSession.chosenMeetpoint = meetpoints[0];
      HomeView.refresh = true;
      return true;
    } else {
      _loadedSession.meetpoints = <Meetpoint_Client>[];
      _loadedSession.chosenMeetpoint = null;
      HomeView.refresh = true;
      return false;
    }

  }

  ///Requests an edit of session details.
  static Future requestSessionEdit({
    @required String sessionId,
    @required String field,
    @required String value,
  }) async {
    //send edit request
    var response = await HttpUtil.postData(
      url: HttpUtil.serverURL,
      data: {
        'method' : Methods.editSession,
        'userId' : _USERID,
        'sessionId' : sessionId,
        'field' : field,
        'value' : value,
      },
      decode: true,
    );

    if (response['result'] == 'O') {
      return true;
    } else {
      throw 'Failed to complete action.\n\nYou might not be connected to the Internet.';
    }
  }

  ///Edits fields of sessions loaded in [_sessions].
  static void updateSession({
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
  }
}

///Holder of constants recognised by server to identify fields in a session; used by requestSessionEdit.
abstract class Field {
  static const String preferredLocationType = 'LT';
  static const String chosenMeetpoint = 'CM';
  static const String user1Address = 'U1A';
  static const String user2Address = 'U2A';
  static const String user1PreferredTravelMode = 'U1T';
  static const String user2PreferredTravelMode = 'U2T';
}

///Holder of constants recognised by server to identify method to invoke.
abstract class Methods {
  static const String saveUser = 'updateUser';
  static const getSessions = 'getSessions';
  static const createSession = 'createSession';
  static const joinSession = 'joinSession';
  static const deleteSession = 'deleteSession';
  static const editSession = 'editSession';
  static const calculate = 'calculate';
  static const getUpdate = 'getUpdate';
}