import 'dart:async';
import 'Entities.dart';

class LocalUserInfoManager {
  static UserDetails localUser;

  static Future loadUser() async {
    //**read from local memory**
    //**load user details into localUser member**
    return _user;
  }

  static Future saveUser() async {
    //**save user details to local memory**
  }
}

UserDetails _user = UserDetails(
  name: 'jon',
  prefStartCoords: Location(
    name: null,
    type: null,
  ),
  prefTravelMode: null,
);