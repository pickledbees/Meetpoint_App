import 'dart:io';
import 'dart:async';
import 'Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class LocalUserInfoManager {
  static UserDetails_Client _localUser;

  static UserDetails_Client get getLocalUser => _localUser;

  static Future loadUser() async {
    UserDetails_Client user;
    try {
      user = await readUserFile();
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
      user.prefStartCoords.type = SessionManager_Client.userId;
      print('saving user...');
      await writeUserFile(user);
      _localUser = user;
      return true;
    } else {
      return false;
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  static Future<UserDetails_Client> readUserFile() async {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();
    return UserDetails_Client.fromJson(json.decode(contents));
  }

  static Future<File> writeUserFile(UserDetails_Client user) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(user.toJson()));
  }
}

UserDetails_Client testUser = UserDetails_Client(
    name: 'dsadsad',
    prefStartCoords: Location_Client(name: 'dsadsadas', type: 'dasdasas'),
    prefTravelMode: 'Car');