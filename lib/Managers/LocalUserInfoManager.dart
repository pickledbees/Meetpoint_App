import 'dart:async';
import 'package:flutter/foundation.dart';
import 'Entities.dart';

class LocalUserInfoManager {
  static UserDetails_Client _localUser;

  static set setLocalUser(UserDetails_Client user) => _localUser = user;
  static UserDetails_Client get getLocalUser => _localUser;

  static Future loadUser() async {
    //**read from local memory**
    //**load user details into localUser member**
    _localUser = TestData.user;
    return _localUser;//localUser;
  }

  static Future saveUser() async {
    //**save user details to local memory**
  }
}