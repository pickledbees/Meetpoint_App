import 'dart:async';
import 'Entities.dart';

class LocalUserInfoManager {
  static UserDetails localUser;

  static Future loadUser() async {
    //**read from local memory**
    //**load user details into localUser member**
    localUser = TestData.user;
    return localUser;//localUser;
  }

  static Future saveUser() async {
    //**save user details to local memory**
  }
}