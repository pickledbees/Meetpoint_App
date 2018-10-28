import 'package:flutter/foundation.dart';

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
    @required name,
    @required type,
    address,
    coordinates,
  }) {
    super.name = name;
    super.type = type;
    super.address = address;
    super.coordinates = coordinates;
  }
}
