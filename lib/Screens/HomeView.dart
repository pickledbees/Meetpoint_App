import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';
import 'package:meetpoint/Screens/SessionView.dart';

class HomeView extends View<HomeController> {

  HomeView(c) : super(controller: c) {
    widget = this;
  }

  static Widget widget; //reference to self for others to access
  bool r = true;

  @override
  Widget build(BuildContext context) {
    if (r) controller.model.loadTiles(context);
    r = false;
    return Scaffold(
      appBar: AppBar(title: Text('Sessions'),),
      body: controller.model.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: () {
              //**navigate to create session view**
            },
          ),
          RaisedButton(
            child: Text('Join'),
            onPressed: () {
              //**navigate to join session view**
            },
          ),
        ],
      ),
    );
  }
}


class HomeController extends Controller<HomeModel> {

  HomeController(m) : super(model: m);

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
    List<Session> sessions = LocalSessionManager.sessions;
    List<ListTile> listTiles = <ListTile>[];
    if (sessions == null) {
      setViewState(() {
        body = Center(
          child: Text(
            'You have no sessions currently'
          ),
        );
      });
    } else {
      for (Session session in sessions) listTiles.add(
          ListTile(
            leading: Icon(Icons.place),
            title: Text(session.title),
            subtitle: Text(session.chosenMeetpoint.name),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              LocalSessionManager.loadSession(sessionId: session.sessionID);

              //navigate to view
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => SessionView(SessionController(SessionModel(session.sessionID))),
              );
              Navigator.push(context, route);

            }, //session id is in here
          )
      );
      setViewState(() {
        body = Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: listTiles,
          ),
        );
      });
    }
  }

}