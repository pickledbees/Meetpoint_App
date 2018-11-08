import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

bool zach = true;

abstract class HttpUtil {
  //for easy changing of ip                     //server                                  //me
  static final String serverURL = zach ? 'http://10.27.108.64:8080/meetpoint' : 'http://10.27.7.227:8080/meetpoint';

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
    @required Map<String,dynamic> data,
    bool decode = true,
  }) async {
    print(data);
    http.Response res = await http
        .post(url, body: zach ? json.encode(data) : data,)
        .timeout(
          Duration(seconds: 10),
          onTimeout: () => throw 'Connection timed out.',
        );
    if (res.statusCode != 200) throw 'Failed to communicate with server';
    print('response recieved');
    return decode ? json.decode(res.body) : res.body;
  }
}