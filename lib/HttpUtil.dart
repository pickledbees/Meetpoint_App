import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

bool zach = false;

abstract class HttpUtil {
  //for easy changing of ip                 //zach                                  //me
  static final String serverURL = zach ? 'http://10.27.196.9:8080/meetpoint' : 'http://192.168.1.161:3000/meetpoint';

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
    var data2send = zach ? json.encode(data) : data;
    http.Response res = await http
        .post(url, body: data2send,)
        .timeout(
          Duration(seconds: 5),
          onTimeout: () => throw 'Failed to communicate with server.\n\nCheck your Internet connection.',
        );
    if (res.statusCode != 200) throw 'Failed to communicate with server';
    return decode ? json.decode(res.body) : res.body;
  }
}