import 'dart:io';
import 'dart:async';
import 'Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

///Manages the information of the local user
class LocalUserInfoManager {
  static UserDetails_Client _localUser;
  static UserDetails_Client get getLocalUser => _localUser;

  ///Reads user file on local system and loads the details as an [UserDetails_Client] object in the [_localUser] field.
  ///Also sets the [userId] property of [SessionManager_Client]
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

  ///Requests a save / update from the server of the local user's details as well as saves user details into local file system.
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

  ///Gets path to default app data file.
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///Gets the default app data file.
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  ///Reads user file and returns the associated [UserDetails_Client] object.
  static Future<UserDetails_Client> _readUserFile() async {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();
    return UserDetails_Client.fromJson(json.decode(contents));
  }

  ///Writes user's details into user file.
  static Future<File> _writeUserFile(UserDetails_Client user) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(user.toJson()));
  }
}