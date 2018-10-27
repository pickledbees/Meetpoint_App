import 'dart:async';
import 'package:flutter/foundation.dart';

Duration timelag = Duration(seconds: 1);
bool success = true;

class LocalSessionManager {
  //token to connect to server
  static final String _TOKEN = 'LOLIPUTZ';

  static List<Session> _sessions;
  static Session _openSession;

  //read-only
  static List<Session> get sessions => _sessions;
  static Session get openSession => _openSession;

  //fetch sessions from server
  static Future fetchSessions() async {
    _sessions = await Future.delayed(timelag, () =>
    success
        ? returned_sessions
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
    //replace with socket request
    String sessionTitle =
    await Future.delayed(timelag, () =>
    success
        ? '456A'
        : throw 'error'
    );
    return sessionTitle;
  }

  //completes to session if success, throws error if failed
  static Future addSession({@required String sessionId}) async {
    //replace with socket request
    return await Future.delayed(timelag, () =>
    success
        ? _sessions.add(returned_session)
        : throw 'error'
    );
  }

  //completes to boolean true if success, throws error if failed
  static Future deleteSession({@required String sessionId}) async {
    //replace with socket request
    return await Future.delayed(timelag, () =>
    success
        ? _sessions.removeAt(_findSession(sessionId))
        : throw 'error'
    );
  }

  //loads session to be the currently open session
  static void loadSession({@required String sessionId}) {
    //replace with socket request
    _openSession = _sessions[_findSession(sessionId)];
  }

  //completes to boolean true if success, throws error if failed
  static Future requestSessionEdit({
    @required String sessionId,
    @required String editCallBack,
    List<Map<String,String>> params
  }) async {
    //replace with socket request
    await Future.delayed(timelag, () =>
    success
        ? success
        : throw 'error'
    );
    //edit local copy if success
    int index = _findSession(sessionId);
    //editMethod parser
    //edit appropriate member in _openSession
  }
}

class Listener {
  //listens for updates
}

List<Session> returned_sessions = (() {
  List<Session> arr;
  for (int i = 0; i < 10; i++) {
    arr.add(
      Session(
        sessionID: '123A',
        title: 'Picnic with fren $i',
        chosenMeetpoint: Meetpoint(
          routeImage: 'path/img.jpg',
          name: 'ParkABC',
          type: 'Park',
        ),
        meetpoints: [
          Meetpoint(
            routeImage: 'path/img.jpg',
            name: 'ParkABC',
            type: 'Park',
          ),
        ],
        prefLocationType: 'Park',
        users: [
          UserDetails(
            name: 'jon',
            prefTravelMode: 'Car',
            prefStartCoords: Location(
              name: 'Home',
              type: 'Housing',
              coordinates: [100.0,200.0],
            ),
          ),
          UserDetails(
            name: 'jane',
            prefTravelMode: 'Walking',
            prefStartCoords: Location(
              name: 'Work',
              type: 'Office',
              coordinates: [200.0,100.0],
            ),
          ),
        ],
        timeCreated: 12134223423.0,
      ),
    );
  }
  return arr;
})();

Session returned_session = Session(
  sessionID: '768Z',
  title: 'Picnic with fren Z',
  chosenMeetpoint: Meetpoint(
    routeImage: 'path/img.jpg',
    name: 'ParkABC',
    type: 'Park',
  ),
  meetpoints: [
    Meetpoint(
      routeImage: 'path/img.jpg',
      name: 'ParkABC',
      type: 'Park',
    ),
  ],
  prefLocationType: 'Park',
  users: [
    UserDetails(
      name: 'jon',
      prefTravelMode: 'Car',
      prefStartCoords: Location(
        name: 'Home',
        type: 'Housing',
        coordinates: [100.0,200.0],
      ),
    ),
    UserDetails(
      name: 'jane',
      prefTravelMode: 'Walking',
      prefStartCoords: Location(
        name: 'Work',
        type: 'Office',
        coordinates: [200.0,100.0],
      ),
    ),
  ],
  timeCreated: 12134223423.0,
);

//Session definition
class Session {
  final String sessionID;
  final String title;
  Meetpoint chosenMeetpoint;
  List<Meetpoint> meetpoints = [];
  String prefLocationType;
  List<UserDetails> users = [];
  double timeCreated;

  Session({
    @required this.sessionID,
    @required this.title,
    this.chosenMeetpoint,
    this.meetpoints,
    @required this.prefLocationType,
    @required this.users,
    @required this.timeCreated,
  });

  int get getNumMeetpoints {
    return null;
  }
}

class UserDetails {
  String name;
  Location prefStartCoords;
  String prefTravelMode;

  UserDetails({
    @required this.name,
    @required this.prefStartCoords,
    @required this.prefTravelMode,
  });
}

class Location {
  String name,type,address; //add address
  List<double> coordinates; //may want to remove

  Location({
    @required this.name,
    @required this.type,
    this.address,
    this.coordinates,
  });
}

class Meetpoint extends Location {
  String routeImage;

  Meetpoint({
    @required this.routeImage,
    @required String name,
    @required String type,
    String address,
    List<double> coordinates,
  }) {
    super.name = name;
    super.type = type;
    super.address = address;
    super.coordinates = coordinates;
  }
}