import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';

class MoreSessionInfoView extends View<MoreSessionInfoController>{

  MoreSessionInfoView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.model.meetpoint.name)),
      body: Center(
        child: Text(controller.model.meetpoint.name),
      ),
    );
  }
}

class MoreSessionInfoController extends Controller<MoreSessionInfoModel> {

  MoreSessionInfoController(m) : super(model: m);

}

class MoreSessionInfoModel extends Model {

  MoreSessionInfoModel(int meetpointIndex) {
    session = SessionManager_Client.getLoadedSession;
    meetpoint = session.meetpoints[meetpointIndex];
  }

  Session_Client session;
  Meetpoint_Client meetpoint;

}