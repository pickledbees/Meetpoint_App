import 'package:flutter/foundation.dart';

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



class TestData {
  static List<Session> returned_sessions = (() {
    List<Session> arr = [];
    for (int i = 0; i < 10; i++) {
      arr.add(
        Session(
          sessionID: '${i}23A',
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
                coordinates: [100.0, 200.0],
              ),
            ),
            UserDetails(
              name: 'jane',
              prefTravelMode: 'Walking',
              prefStartCoords: Location(
                name: 'Work',
                type: 'Office',
                coordinates: [200.0, 100.0],
              ),
            ),
          ],
          timeCreated: 12134223423.0,
        ),
      );
    }
    return arr;
  })();

  static int count = 0;

  static Session created_session (String sessionTitle) => Session(
    sessionID: '${count++}Z',
    title: sessionTitle,
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


  static Session joined_session (String sessionId) => Session(
    sessionID: sessionId,
    title: 'Picnic with fren $sessionId',
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

  static UserDetails user = UserDetails(
    name: 'jon',
    prefStartCoords: Location(
      name: null,
      type: null,
    ),
    prefTravelMode: null,
  );
}