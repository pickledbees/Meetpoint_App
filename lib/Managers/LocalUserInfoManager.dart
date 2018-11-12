import 'dart:io';
import 'dart:async';
import 'Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class LocalUserInfoManager {
  static UserDetails_Client _localUser;
  //enable read-only from outside
  static UserDetails_Client get getLocalUser => _localUser;

  static Future loadUser() async {
    UserDetails_Client user;
    try {
      user = await _readUserFile();
    } catch (error) {
      return null;
    }
    print('loading user...');
    _localUser = user;
    //loads user id into SessionManager_Client
    SessionManager_Client.userId = user.prefStartCoords.type;
    return _localUser;
  }
  static Future saveUser(UserDetails_Client user) async {
    bool success = await SessionManager_Client.saveUser(user);
    if (success) {
      //assign id to user detail
      user.prefStartCoords.type = SessionManager_Client.userId;
      print('saving user...');
      //write user to file
      await _writeUserFile(user);
      _localUser = user;
      return true;
    } else {
      return false;
    }
  }

  //below methods are private
  //getters for file and directory path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }
  //reader for the file
  static Future<UserDetails_Client> _readUserFile() async {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();
    return UserDetails_Client.fromJson(json.decode(contents));
  }
  //writer for the file
  static Future<File> _writeUserFile(UserDetails_Client user) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(user.toJson()));
  }
}