import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

abstract class HttpUtil {
  //for easy changing of ip
  static const String serverURL = 'http://10.27.7.227:3000/Meetpoint';
  static final _Methods _methods= const _Methods();

  static _Methods get methods => _methods;

  //returns a map or string depending on 'decode' setting, throw the error code
  static Future getData({
    @required String url,
    bool decode = true,
  }) async {
    http.Response res = await http.post(url);
    if (res.statusCode != 200) throw res.statusCode;
    return decode ? json.decode(res.body) : res.body;
  }

  //returns a map or string depending on 'decode' setting, throw the error code
  static Future postData({
    @required String url,
    @required Map data,
    bool decode = true,
  }) async {
    http.Response res = await http.post(url, body: data);
    if (res.statusCode != 200) throw res.statusCode;
    return decode ? json.decode(res.body) : res.body;
  }
}

class _Methods {
  const _Methods();
  final String saveUser = 'updateUser';
  final String getSessions = 'getSessions';
  final String createSession = 'createSession';
  final String joinSession = 'joinSession';
  final String deleteSession = 'deleteSession';
  final String editSession = 'editSession';
  final String calculate = 'calculate';
}