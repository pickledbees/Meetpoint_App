import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'HomeView.dart';

class InitialiserView extends View<InitialiserController> {
  InitialiserView(c) : super(controller : c);

  @override
  Widget build(BuildContext context) {
    controller.initialise();
    return Scaffold(
      body: Center(
        child: Text('Meetpoint'),
      ),
    );
  }
}

class InitialiserController extends Controller {
  initialise() async {
    //**check if first start**
    await LocalSessionManager.fetchSessions();
  }
}