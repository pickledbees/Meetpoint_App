import 'package:flutter/foundation.dart';

//Session_Client definition
class Session_Client {
  final String sessionID;
  final String title;
  Meetpoint_Client chosenMeetpoint;
  List<Meetpoint_Client> meetpoints = [];
  String prefLocationType;
  List<UserDetails_Client> users = [];
  double timeCreated;

  Session_Client({
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

class UserDetails_Client {
  String name;
  Location_Client prefStartCoords;
  String prefTravelMode;

  UserDetails_Client({
    @required this.name,
    @required this.prefStartCoords,
    @required this.prefTravelMode,
  });
}

class Location_Client {
  String name,type,address; //add address
  List<double> coordinates; //may want to remove

  Location_Client({
    @required this.name,
    @required this.type,
    this.address,
    this.coordinates,
  });
}

class Meetpoint_Client extends Location_Client {
  String routeImage;

  Meetpoint_Client({
    @required this.routeImage,
    @required String name,
    @required String type,
    String address,
    List<double> coordinates,
  }) {
    super.name  = name;
    super.type = type;
    super.address = address;
    super.coordinates = coordinates;
  }
}



class TestData {
  static List<Session_Client> returned_sessions = (() {
    List<Session_Client> arr = [];
    for (int i = 0; i < 10; i++) {
      arr.add(
        Session_Client(
          sessionID: '${i}23A',
          title: 'Picnic with fren $i',
          chosenMeetpoint: Meetpoint_Client(
            routeImage: 'path/img.jpg',
            name: 'ParkABC',
            type: 'Park',
            coordinates: [0.0,0.0],
          ),
          meetpoints: [
            Meetpoint_Client(
              routeImage: 'path/img.jpg',
              name: 'ParkABC',
              type: 'Park',
              coordinates: [0.0,0.0],
            ),
            Meetpoint_Client(
              routeImage: 'path/img.jpg',
              name: 'ParkABD',
              type: 'Park',
              coordinates: [0.0,0.0],
            ),
            Meetpoint_Client(
              routeImage: 'path/img.jpg',
              name: 'ParkABE',
              type: 'Park',
              coordinates: [0.0,0.0],
            ),
          ],
          prefLocationType: 'Park',
          users: [
            UserDetails_Client(
              name: 'jon',
              prefTravelMode: 'Car',
              prefStartCoords: Location_Client(
                name: 'Home',
                type: 'Housing',
                address: 'Block 1234',
                coordinates: [100.0, 200.0],
              ),
            ),
            UserDetails_Client(
              name: 'jane',
              prefTravelMode: 'Walking',
              prefStartCoords: Location_Client(
                name: 'Work',
                type: 'Office',
                address: 'Block 324657',
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

  static Session_Client created_session (String sessionTitle) => Session_Client(
    sessionID: '${count++}Z',
    title: sessionTitle,
    chosenMeetpoint: null,
    meetpoints: <Meetpoint_Client>[],
    prefLocationType: 'No Preference',
    users: [
      UserDetails_Client(
        name: 'jon',
        prefTravelMode: 'Car',
        prefStartCoords: Location_Client(
          name: 'Home',
          type: 'Housing',
          address: 'Home',
          coordinates: [100.0,200.0],
        ),
      ),
      UserDetails_Client(
        name: null,
        prefTravelMode: 'No Preference',
        prefStartCoords: Location_Client(
          name: null,
          type: null,
          address: null,
          coordinates: [null,null],
        ),
      ),
    ],
    timeCreated: 12134223423.0,
  );


  static Session_Client joined_session (String sessionId) => Session_Client(
    sessionID: sessionId,
    title: 'Picnic with fren $sessionId',
    chosenMeetpoint: Meetpoint_Client(
      routeImage: 'path/img.jpg',
      name: 'ParkABC',
      type: 'Park',
    ),
    meetpoints: [
      Meetpoint_Client(
        routeImage: 'path/img.jpg',
        name: 'ParkABC',
        type: 'Park',
      ),
      Meetpoint_Client(
        routeImage: 'path/img.jpg',
        name: 'ParkABD',
        type: 'Park',
      ),
      Meetpoint_Client(
        routeImage: 'path/img.jpg',
        name: 'ParkABE',
        type: 'Park',
      ),
    ],
    prefLocationType: 'Park',
    users: [
      UserDetails_Client(
        name: 'jon',
        prefTravelMode: 'Car',
        prefStartCoords: Location_Client(
          name: 'Home',
          type: 'Housing',
          address: 'Block 203',
          coordinates: [100.0,200.0],
        ),
      ),
      UserDetails_Client(
        name: 'jane',
        prefTravelMode: 'Walking',
        prefStartCoords: Location_Client(
          name: 'Work',
          type: 'Office',
          address: 'Office 21',
          coordinates: [200.0,100.0],
        ),
      ),
    ],
    timeCreated: 12134223423.0,
  );

  static UserDetails_Client user = UserDetails_Client(
    name: 'jon',
    prefStartCoords: Location_Client(
      name: null,
      type: null,
    ),
    prefTravelMode: null,
  );
}