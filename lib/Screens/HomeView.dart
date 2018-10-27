import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/LocalInfoManagers/Entities.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';

class HomeView extends View<HomeController> {

  HomeView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    controller.loadPage();
    return Scaffold(
      appBar: AppBar(title: Text('Sessions'),),
      body: controller.model.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: () => controller.createSession(sessionTitle: null),
          ),
          RaisedButton(
            child: Text('Join'),
            onPressed: () => controller.removeSession(sessionId: null),
          ),
        ],
      ),
    );
  }
}

class HomeController extends Controller<HomeModel> {

  HomeController(m) : super(model: m);

  loadPage() async {
    try {
      await LocalSessionManager.fetchSessions();
      model.loadTiles();
    } catch (e) {
      //error message
    }
  }

  createSession({@required String sessionTitle}) async {
    try {
      String sessionId =
      await LocalSessionManager.createSession(sessionTitle: sessionTitle);
      await LocalSessionManager.addSession(sessionId: sessionId);
      model.loadTiles();
      //navigate to session page
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

  goToSession({@required String sessionId}) {
    LocalSessionManager.loadSession(sessionId: sessionId);
    //navigate to session page
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
    List<ListTile> listTiles = [];
    for (Session session in sessions) listTiles.add(
      ListTile(
        leading: Icon(Icons.place),
        title: Text(session.title),
        subtitle: Text(session.chosenMeetpoint.name),
        trailing: Icon(Icons.chevron_right),
        onTap: null, //session id is in here
      )
    );
    setViewState(() {
      body = ListView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 75.0),
        children: listTiles,
      );
    });
  }
}