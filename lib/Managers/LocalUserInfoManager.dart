import 'dart:async';
import 'package:flutter/foundation.dart';
import 'Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';

class LocalUserInfoManager {
  static UserDetails_Client _localUser;

  static set setLocalUser(UserDetails_Client user) => _localUser = user;
  static UserDetails_Client get getLocalUser => _localUser;

  static Future loadUser() async {
    //**read from local memory**
    //**load user details into localUser member**
    _localUser = TestData.user;
    return _localUser;
  }

  static Future saveUser(UserDetails_Client user) async {
    bool result = await SessionManager_Client.saveUser(user);
    //if error throw necessary dialog
    _localUser = user;
    return result;
  }
}