import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'dart:async';
import 'package:meetpoint/LocalSessionManager.dart';

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



/*
class HomeViewUI extends StatefulWidget {
  //call this to reload state
  @override
  _HomeViewUIState createState() => _HomeViewUIState();
}

class _HomeViewUIState extends State<HomeViewUI> {

  List<ListTile> sessionTiles;

  @override
  Widget build(BuildContext context) {

    loadSessionTiles();

    return Scaffold(
      appBar: AppBar(title: Text('Sessions'),),
      body: Center(
        child: ListView(
          children: sessionTiles,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: (){
              //go to create session view
            },
          ),
          RaisedButton(
            child: Text('Join'),
            onPressed: (){
              //go to join session view
            },
          ),
        ],
      ),
    );
  }

  List<Map<String,String>> getSessions() {
    //request sessions list via controller
    //get sessions list via model
    //model calls create state to update

    //OR

    //request sessions list via model
    return null;
  }

  List<DropdownMenuItem> makeSessionTiles() {
    //produce list of session tiles
    return null;
  }

  void loadSessionTiles() {
    //load session tiles
  }
}
*/