import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:meetpoint/Managers/LocalUserInfoManager.dart';
import 'package:meetpoint/HttpUtil.dart';
import 'FirstStartView.dart';
import 'HomeView.dart';
import 'package:web_socket_channel/io.dart';

class InitialiserView extends View<InitialiserController> {
  InitialiserView(c) : super(controller : c);
  bool r = true;

  @override
  Widget build(BuildContext context) {
    if (r) controller.initialise(context);
    r = false;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Meetpoint',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Color.fromRGBO(11, 143, 160, 1.0),
                ),
              ),
            ),
            Text(
              controller.model.loaderText,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialiserController extends Controller<InitialiserModel> {
  InitialiserController(m) : super(model : m);

  initialise(BuildContext context) async {
    //load user
    UserDetails_Client user = await LocalUserInfoManager.loadUser();

    if (user == null) {
      //pause
      await Future.delayed(Duration(seconds: 1));
      //open channel
      model.setLoaderTextTo('Connecting to server...');
      SessionManager_Client.channel = IOWebSocketChannel.connect('ws://echo.websocket.org');//'ws://echo.websocket.org'//'ws://10.27.196.9:9090'
      //navigate to first start view
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => FirstStartView(FirstStartController(FirstStartModel())),
      );
      Navigator.pushReplacement(context, route,);

    } else {

      try {
        //fetch sessions
        model.setLoaderTextTo('Fetching your sessions...');
        await SessionManager_Client.fetchSessions();
        //open channel
        model.setLoaderTextTo('Connecting to server...');
        SessionManager_Client.channel = IOWebSocketChannel.connect('ws://echo.websocket.org');//'ws://echo.websocket.org'
        //show welcome
        model.setLoaderTextTo('Welcome ${LocalUserInfoManager.getLocalUser.name}');
        await Future.delayed(Duration(seconds: 1)); //pause
        //navigate to home view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => HomeView(HomeController(HomeModel())),
        );
        Navigator.pushReplacement(context, route,);

      } catch (e) {
        //**print appropriate error message**
        print(e);
      }
    }
  }
}

class InitialiserModel extends Model {
  String loaderText = 'Loading...';

  setLoaderTextTo(String txt) {
    setViewState(() => loaderText = txt);
  }
}