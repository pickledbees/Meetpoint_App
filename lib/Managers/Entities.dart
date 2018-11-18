import 'package:flutter/foundation.dart';
import 'LocalUserInfoManager.dart';

///Represents a session joined / created by a user.
///A user can have many sessions.
class Session_Client {
  final String sessionID;
  final String title;
  Meetpoint_Client chosenMeetpoint;
  List<Meetpoint_Client> meetpoints = [];
  String prefLocationType;
  List<UserDetails_Client> users = [];
  int timeCreated;

  Session_Client({
    @required this.sessionID,
    @required this.title,
    this.chosenMeetpoint,
    this.meetpoints,
    @required this.prefLocationType,
    @required this.users,
    this.timeCreated,
  });

  ///Returns the index of a particular instance of [Meetpoint_Client] object in [meetpoints] given the name of [chosenMeetpoint]
  int get chosenMeetpointIndex {
    int index = 0;
    if (chosenMeetpoint == null) return -1;
    for (Meetpoint_Client meetpoint in meetpoints) {
      if (meetpoint.name == chosenMeetpoint.name) return index;
      index++;
    }
  }
}

///Represents a single user and his/her associated details.
///Present in multiples inside a [Session_Client] object.
class UserDetails_Client {
  String name;
  Location_Client prefStartCoords;
  String prefTravelMode;

  UserDetails_Client({
    @required this.name,
    @required this.prefStartCoords,
    @required this.prefTravelMode,
  });

  ///Converts a [Map] object into a [UserDetails_Client] object, used by [LocalUserInfoManager] for conversions.
  UserDetails_Client.fromJson(Map<String,dynamic> map) {
    name = map['name'];
    prefStartCoords = Location_Client(
      name: map['address'],
      type: map['id'],
      address: map['address'],
    );
    prefTravelMode = map['preTravelMode'];
  }

  ///Converts a [UserDetails_Client] object into a [Map] object, used by [LocalUserInfoManager] for conversions.
  Map<String,dynamic> toJson() {
    return {
      'name': name,
      'address' : prefStartCoords.address,
      'preTravelMode' : prefTravelMode,
      'id' : prefStartCoords.type,
    };
  }

}

///Represents a location and its associated details.
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

///Represents a Meetpoint and its associated details.
class Meetpoint_Client extends Location_Client {
  String routeImage;
  String routeImage2;

  Meetpoint_Client({
    @required this.routeImage,
    @required this.routeImage2,
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