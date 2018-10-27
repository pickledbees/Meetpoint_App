import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';

class HomeView extends View<HomeController> {

  HomeView(c) : super(controller: c) {
    widget = this;
  }

  static Widget widget; //reference to self for others to access

  @override
  Widget build(BuildContext context) {
    controller.model.loadTiles();
    return Scaffold(
      appBar: AppBar(title: Text('Sessions'),),
      body: controller.model.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: () {
              controller.createSession(sessionTitle: null);
              //**navigate to session**
            },
          ),
          RaisedButton(
            child: Text('Join'),
            onPressed: () {
              controller.removeSession(sessionId: null);
              //**navigate to session**
            },
          ),
        ],
      ),
    );
  }
}

class HomeController extends Controller<HomeModel> {

  HomeController(m) : super(model: m);

  createSession({@required String sessionTitle}) async {
    try {
      String sessionId =
      await LocalSessionManager.createSession(sessionTitle: sessionTitle);
      await LocalSessionManager.addSession(sessionId: sessionId);
      model.loadTiles();
    } catch (e) {
      //error message
    }
  }

  joinSession({@required String sessionId}) async {
    try {
      await LocalSessionManager.addSession(sessionId: sessionId);
      model.loadTiles();
      //navigate to session page
    } catch (e) {
      //error message
    }
  }

  removeSession({@required String sessionId}) async {
    try {
      await LocalSessionManager.deleteSession(sessionId: sessionId);
      model.loadTiles();
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

  loadTiles() {
    List<Session> sessions = LocalSessionManager.sessions;
    List<ListTile> listTiles = <ListTile>[];
    if (sessions == null) {print('no sessions'); return;}
    for (Session session in sessions) listTiles.add(
      ListTile(
        leading: Icon(Icons.place),
        title: Text(session.title),
        subtitle: Text(session.chosenMeetpoint.name),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          LocalSessionManager.loadSession(sessionId: session.sessionID);
          //navigate to session view
        }, //session id is in here
      )
    );
    setViewState(() {
      body = Center(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 75.0),
          children: listTiles,
        ),
      );
    });
  }

}