import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';

class MoreSessionInfoView extends View<MoreSessionInfoController>{

  MoreSessionInfoView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class MoreSessionInfoController extends Controller<MoreSessionInfoModel> {

  MoreSessionInfoController(m) : super(model: m);

}

class MoreSessionInfoModel extends Model {

  MoreSessionInfoModel(int meetpointIndex) {
    session = LocalSessionManager.getLoadedSession;
    meetpoint = session.meetpoints[meetpointIndex];
  }

  Session session;
  Meetpoint meetpoint;

}