import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/LocalInfoManagers/LocalUserInfoManager.dart';
import 'FirstStartView.dart';
import 'HomeView.dart';

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
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Meetpoint',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.blueGrey,
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

    UserDetails user = await LocalUserInfoManager.loadUser();

    if (user == null) {

      await Future.delayed(Duration(seconds: 2)); //pause

      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => FirstStartView(FirstStartController(FirstStartModel())),
      );
      Navigator.pushReplacement(context, route,);

    } else {

      try {

        model.setLoaderTextTo('Fetching your sessions...');
        await LocalSessionManager.fetchSessions();

        model.setLoaderTextTo('Welcome ${LocalUserInfoManager.localUser.name}');
        await Future.delayed(Duration(seconds: 1)); //pause

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