import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/LocalInfoManagers/LocalUserInfoManager.dart';
import 'HomeView.dart';

class InitialiserView extends View<InitialiserController> {

  InitialiserView(c) : super(controller : c);

  @override
  Widget build(BuildContext context) {
    controller.initialise();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Meetpoint'),
            Text(controller.model.loaderText),
          ],
        ),
      ),
    );
  }
}

class InitialiserController extends Controller<InitialiserModel> {

  InitialiserController(m) : super(model : m);

  initialise() async {
    UserDetails user = await LocalUserInfoManager.loadUser();
    if (user != null) {
      try {
        model.setLoaderTextTo('Fetching your sessions...');
        await LocalSessionManager.fetchSessions();
        model.setLoaderTextTo('Welcome ${LocalUserInfoManager.localUser.name}');
        //**navigate to home view**
      } catch (e) {
        //**print appropriate error message**
      }
    } else {
      //**navigate to first start view**
    }
  }
}

class InitialiserModel extends Model {

  String loaderText = 'Loading...';

  setLoaderTextTo(String txt) {
    setViewState(() => loaderText = txt);
  }
}