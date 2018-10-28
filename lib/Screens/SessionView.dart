import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'MoreSessionInfoUI.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/Standards/LocationTypes.dart';

class SessionView extends View<SessionController> {
  SessionView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.model.session.title),),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0,),
        child: Column(
          children: <Widget>[
            //primer bar
            Widgets.primer(),
            //id prompt
            Widgets.sessionIdPrompt(controller.model.session.sessionID),
            //users joined in session
            Widgets.usersBar([controller.model.session.users[0].name, controller.model.session.users[1].name]),
            //map display
            Widgets.mapsDisplay(),
            //dropdown menu for preferred location types
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    'Preferred Area:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  child: DropdownButton(
                    value: controller.model.preferredLocationType,
                    items: Widgets.dropdownItems(),
                    onChanged: controller.updatePreferredLocation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SessionController extends Controller<SessionModel> {
  SessionController(m) : super(model: m);

  updatePreferredLocation(val) {
    model.updatePreferredLocation(val);
  }
}

class SessionModel extends Model {

  SessionModel(String sessionId) {
    //load session
    LocalSessionManager.loadSession(sessionId: sessionId);
    session = LocalSessionManager.openSession;
  }

  Session session;
  String preferredLocationType = LocationTypes.list[0];

  updatePreferredLocation(val) {
    setViewState(() => preferredLocationType = val);
  }

}

//for widgets to display
class Widgets {
  static Widget primer() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 7.0),
      child: Text(
        'Others can join this meeting with the following ID',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  static Widget sessionIdPrompt(String sessionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          child: Text(
            sessionId,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          child: Icon(
            Icons.content_copy,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  static Widget usersBar(List<String> users) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),//users row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5.0),
            child: Icon(Icons.person),
          ),
          Container(
            margin: EdgeInsets.only(right: 5.0),
            child: Text('Joined:'),
          ),
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Text(users[0]),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(users[1]),
          ),
        ],
      ),
    );
  }

  static Widget mapsDisplay() {
    return Container(
      color: Colors.black12,
      height: 300.0,
      child: PageView(
        children: <Widget>[
          Text('1'),
          Text('2'),
          Text('3'),
        ],
      ),
    );
  }

  static List<DropdownMenuItem> dropdownItems() {
    List<DropdownMenuItem> items = [];
    List<String> types = LocationTypes.list;
    for (String type in types) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(type),
        value: type,
      );
      items.add(item);
    }
    return items;
  }
}