import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

bool deployed = true;

abstract class HttpUtil {
  //for easy changing of ip                        //server                                  //me
  static final String serverURL = deployed ? 'http://10.27.196.9:8080/meetpoint' : 'http://192.168.0.183:3333/';

  //returns a map or string depending on 'decode' setting, throw the error code
  ///Sends a POST request to the server and asynchronously returns the response body upon reception of the response.
  static Future postData({
    @required String url,
    @required Map<String,dynamic> data,
    bool decode = true,
  }) async {
    print(data);
    http.Response res = await http
        .post(url, body: deployed ? json.encode(data) : data)
        .timeout(
          Duration(seconds: 20),
          onTimeout: () => throw 'Connection timed out.',
        );
    if (res.statusCode != 200) throw 'Failed to communicate with server';
    print('response recieved');
    return decode ? json.decode(res.body) : res.body;
  }
}