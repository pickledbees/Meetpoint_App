import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/Screens/SessionView.dart';
import 'package:meetpoint/Screens/CreateSessionView.dart';
import 'package:meetpoint/Screens/JoinSessionView.dart';

class HomeView extends View<HomeController> {

  HomeView(c) : super(controller: c) {
    widget = this;
  }

  static Widget widget; //reference to self for others to access
  static bool refresh = true;

  @override
  Widget build(BuildContext context) {
    if (refresh) controller.model.loadTiles(context);
    refresh = false;
    return Scaffold(
      appBar: AppBar(title: Text('Sessions'),),
      body: controller.model.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: () => controller.navigateToCreateSession(context),
          ),
          RaisedButton(
            child: Text('Join'),
            onPressed: () => controller.navigateToJoinSession(context),
          ),
        ],
      ),
    );
  }
}

class HomeController extends Controller<HomeModel> {

  HomeController(m) : super(model: m);

  navigateToCreateSession(BuildContext context) {
    //navigate to create session view
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => CreateSessionView(CreateSessionController(CreateSessionModel())),
    );
    Navigator.push(context, route,);
  }

  navigateToJoinSession(BuildContext context) {
    //navigate to join session view
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => JoinSessionView(JoinSessionController(JoinSessionModel())),
    );
    Navigator.push(context, route,);
  }

  removeSession({@required String sessionId, BuildContext context}) async {
    try {
      await LocalSessionManager.deleteSession(sessionId: sessionId);
      model.loadTiles(context);
      //navigate to session page
    } catch (e) {
      //error message
    }
  }
}


class HomeModel extends Model {
  
  Widget body = Center(
    child: Text(
      'Loading...',
      textScaleFactor: 1.3,
    ),
  );

  loadTiles(BuildContext context) {
    List<Session> sessions = LocalSessionManager.getSessions;
    List<ListTile> listTiles = <ListTile>[];
    if (sessions.length == 0) {
      setViewState(() {
        body = Center(
          child: Text(
            'You have no sessions currently'
          ),
        );
      });
    } else {
      //generate tiles
      for (Session session in sessions) listTiles.add(
          ListTile(
            leading: Icon(Icons.place),
            title: Text(session.title),
            subtitle: Text(session.chosenMeetpoint?.name ?? 'No chosen meetpoint'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              //navigate to view
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => SessionView(SessionController(SessionModel(session.sessionID))),
              );
              Navigator.push(context, route);
            },
          )
      );
      //update display
      setViewState(() {
        body = Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            children: listTiles,
          ),
        );
      });
    }
  }

}