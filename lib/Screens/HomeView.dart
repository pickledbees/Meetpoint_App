import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:meetpoint/Screens/SessionView.dart';
import 'package:meetpoint/Screens/CreateSessionView.dart';
import 'package:meetpoint/Screens/JoinSessionView.dart';
import 'package:meetpoint/Screens/FirstStartView.dart';

///Represents the [View] portion of the Home View.
class HomeView extends View<HomeController> {
  HomeView(c) : super(controller: c) {
    widget = this;
  }

  static HomeView widget; //reference to self object for others to access
  static BuildContext viewContext;
  ///Toggled to trigger lazy refresh of [HomeView]
  static bool refresh = true;

  ///Builds up [Widget] tree of vieww
  @override
  Widget build(BuildContext context) {
    viewContext = context;
    if (refresh) controller.refresh(context); //TODO: test with actual server
    //if (refresh) controller.model.loadTiles(context);
    refresh = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - Your Sessions'),
        leading: Icon(Icons.home),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.refresh(context),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 50.0,
              color: Color.fromRGBO(11, 143, 160, 1.0),
              child: Center(
                child: Text(
                  'Meetpoint',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              )
            ),
            Container(
              height: 10.0,
              color: Color.fromRGBO(11, 143, 160, 0.5),
            ),
            Container(
              height: 5.0,
              color: Colors.deepOrange,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 30.0, 0.0),
              leading: Icon(
                Icons.account_circle,
                size: 40.0,
              ),
              title: Text('Default Information'),
              onTap: () => controller.navigateToFirstStartView(context),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 30.0, 0.0),
              leading: Icon(
                Icons.info_outline,
                size: 40.0,
              ),
              title: Text('About'),
              onTap: null,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 30.0, 0.0),
              leading: Icon(
                Icons.help,
                size: 40.0,
              ),
              title: Text('Help'),
              onTap: null,
            ),
          ],
        ),
      ),
      body: controller.model.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text('Join'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Icon(Icons.people),
                ),
              ],
            ),
            onPressed: () => controller.navigateToJoinSession(context),
          ),
          RaisedButton(
            color: Colors.deepOrange,
            splashColor: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            onPressed: () => controller.navigateToCreateSession(context),
          ),
        ],
      ),
    );
  }
}

///Represents the [Controller] portion of the Home View.
class HomeController extends Controller<HomeModel> {
  HomeController(m) : super(model: m) ;
  bool get isMounted => mounted;

  ///Navigates user to the [CreateSessionView]
  navigateToCreateSession(BuildContext context) {
    HomeView.refresh = true;
    //navigate to create session view
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => CreateSessionView(CreateSessionController(CreateSessionModel())),
    );
    Navigator.push(context, route,);
  }

  ///Navigates user to the [JoinSessionView]
  navigateToJoinSession(BuildContext context) {
    HomeView.refresh = true;
    //navigate to join session view
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => JoinSessionView(JoinSessionController(JoinSessionModel())),
    );
    Navigator.push(context, route,);
  }

  ///Navigates user to the [FirstStartView]
  navigateToFirstStartView(BuildContext context) {
    HomeView.refresh = true;
    //navigate to first start view
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => FirstStartView(FirstStartController(FirstStartModel())),
    );
    Navigator.pushReplacement(context, route,);
  }

  ///Prompts for a fetching of sessions by calling on the [SessionManager_Client] and refreshes the [HomeView].
  refresh(BuildContext context) async {
    setViewState(() => model.body = Center(child: Text('Refreshing...')));
    try {
      await SessionManager_Client.fetchSessions();
    } catch (error) {
      model.showErrorDialog('Failed to refresh sessions');
    }
    model.loadTiles(context);
  }
}

///Represents the [Model] portion of the Home View.
class HomeModel extends Model {

  ///Default [Text] in place of [ListView] of sessions in [HomeView].
  Widget body = Center(
    child: Text('Loading...'),
  );

  ///Assembles sessions data required for [ListView] of sessions in [HomeView].
  loadTiles(BuildContext context) {
    List<Session_Client> sessions = SessionManager_Client.getSessions;
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
      for (Session_Client session in sessions) listTiles.add(
          ListTile(
            leading: Icon(
              Icons.place,
              color: Colors.deepOrange,
              size: 30.0,
            ),
            title: Text(
              session.title,
              textScaleFactor: 1.05,
            ),
            subtitle: Text(session.chosenMeetpoint?.name ?? 'No chosen meetpoint'),
            trailing: Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              SessionManager_Client.fetchSessions().then((_) {
                //navigate to view
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => SessionView(SessionController(SessionModel(session.sessionID))),
                );
                Navigator.push(context, route);
              });
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

  ///Shows error dialog box.
  showErrorDialog(error) {
    showDialog(
        context: HomeView.viewContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        }
    );
  }
}