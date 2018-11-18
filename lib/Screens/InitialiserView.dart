import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:meetpoint/Managers/LocalUserInfoManager.dart';
import 'FirstStartView.dart';
import 'HomeView.dart';
import 'package:http/http.dart' as http;

///Represents the [View] portion of the Initialiser View.
class InitialiserView extends View<InitialiserController> {
  InitialiserView(c) : super(controller : c) {
    view = this;
  }
  static InitialiserView view;
  ///Toggled to prevent intilialising application twice.
  bool r = true;
  static BuildContext viewContext;

  ///Builds up [Widget] tree of view.
  @override
  Widget build(BuildContext context) {
    viewContext = context;
    if (r) controller.initialise();
    r = false;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.place,
              size: 150.0,
              color: Colors.deepOrange,
            ),
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

///Represents the [Controller] portion of the Initialiser View.
class InitialiserController extends Controller<InitialiserModel> {
  InitialiserController(m) : super(model : m);

  ///Performs initialising sequence
  initialise() async {
    //load user
    UserDetails_Client user = await LocalUserInfoManager.loadUser();

    if (user == null) {
      //pause
      await Future.delayed(Duration(seconds: 1));
      //navigate to first start view
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => FirstStartView(FirstStartController(FirstStartModel())),
      );
      Navigator.pushReplacement(InitialiserView.viewContext, route,);

    } else {

      try {
        //fetch sessions
        model.setLoaderTextTo('Fetching your sessions...');
        await SessionManager_Client.fetchSessions();
        //show welcome
        model.setLoaderTextTo('Welcome ${LocalUserInfoManager.getLocalUser.name}');
        await Future.delayed(Duration(seconds: 1));
        //navigate to home view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => HomeView(HomeController(HomeModel())),
        );
        Navigator.pushReplacement(InitialiserView.viewContext, route,);

      } catch (error) {
        model.showErrorDialog("Could not fetch sessions\n\nYou may not be connected to the Internet or the server is not responding correctly.");
      }
    }
  }
}

///Represents the [Model] portion of the Initialiser View.
class InitialiserModel extends Model {
  String loaderText = 'Loading...';

  ///Changes subtext below application name onscreen to appropriate message
  setLoaderTextTo(String txt) {
    setViewState(() => loaderText = txt);
  }

  ///Shows error dialog box.
  showErrorDialog(error) {
    showDialog(
        context: InitialiserView.viewContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text(error),
            actions: <Widget>[
              FlatButton(
                child: Text('Try again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  InitialiserView.view.controller.initialise();
                },
              ),
            ],
          );
        }
    );
  }
}