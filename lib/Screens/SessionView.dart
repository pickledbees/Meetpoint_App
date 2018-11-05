import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/Standards/LocationTypes.dart';
import 'package:meetpoint/Screens/MoreSessionInfoView.dart';
import 'package:meetpoint/Screens/HomeView.dart';

class SessionView extends View<SessionController> {
  SessionView(c) : super(controller: c) {
    widget = this;
  }

  static BuildContext viewContext; //for access for dynamically built navigation buttons
  static SessionView widget; //reference to self object for others to access

  @override
  Widget build(BuildContext context) {
    viewContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.model.session.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {controller.promptDelete();},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0,),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: <Widget>[

              //primer bar----------------------------------------------------------------
              primer(),

              //id prompt-----------------------------------------------------------------
              sessionIdPrompt(controller.model.session.sessionID),

              //users joined in session---------------------------------------------------
              usersBar(controller.model.session.users), //TODO:find some way to update this-----------

              //maps display--------------------------------------------------------------
              Divider(height: 20.0,),
              Container(
                height: 308.0,
                child: controller.model.mapsDisplay,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.deepOrange,
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => controller.calcMeetpoints(), //TODO: think about how to validate-----------------
                  ),
                  Container(width: 10.0,),
                ],
              ),
              Divider(height: 20.0,),
              //dropdown menu for preferred location types--------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(width: 30.0,),
                  Container(
                    child: DropdownButton(
                      value: controller.model.preferredLocationType,
                      items: prefLocationTypeDropdownItems(),
                      onChanged: controller.sendUpdatePreferredLocation,
                    ),
                  ),
                ],
              ),

              //user 1 fields------------------------------------------------------------
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,25.0,0.0),
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: controller.address1,
                            validator: controller.validate,
                            decoration: InputDecoration(
                              hintText: 'Address',
                            ),
                            onEditingComplete: controller.sendUpdateAddress1,
                          ),
                          DropdownButton(
                            value: controller.model.preferredTravelMode1,
                            items: prefTravelModeDropdownItems(),
                            onChanged: controller.sendUpdatePreferredTravelMode1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //user 2 fields--------------------------------------------------------------
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,25.0,0.0),
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: controller.address2,
                            validator: controller.validate,
                            decoration: InputDecoration(
                              hintText: 'Address',
                            ),
                            onEditingComplete: controller.sendUpdateAddress2,
                          ),
                          DropdownButton(
                            value: controller.model.preferredTravelMode2,
                            items: prefTravelModeDropdownItems(),
                            onChanged: controller.sendUpdatePreferredTravelMode2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //empty space + stream handler
              Container(
                height: 200.0,
              ),
            ],
          ),
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          print('test data sent');
          Map data = {
            'method' : 'editSession',
            'sessionId' : '123A',
            'field' : 'CM',
            'value' : '2',
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          };
          //SessionManager_Client.channel.sink.add(json.encode(data));
          SessionManager_Client.channel.sink.add(1312423);
        },
      ),
      */
    );
  }

  //generate primer text
  static Widget primer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 7.0),
      child: Text(
        'Others can join this meeting with the following session ID',
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  //generate session id display
  static Widget sessionIdPrompt(String sessionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Text(
            sessionId,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Icon(
            Icons.content_copy,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  //generate users in users bar
  static Widget usersBar(List<UserDetails_Client> users) {
    List<Widget> bar = [
      Container(
        margin: const EdgeInsets.only(right: 5.0),
        child: Icon(Icons.person),
      ),
      Container(
        margin: const EdgeInsets.only(right: 5.0),
        child: Text(
          'Joined:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    ];
    for (UserDetails_Client user in users) {
      bar.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(user.name ?? ''),
        )
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),//users row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: bar,
      ),
    );
  }

  //generate location type dropdown list
  static List<DropdownMenuItem> prefLocationTypeDropdownItems() {
    List<DropdownMenuItem> items = [];
    List<String> types = LocationTypes.getList;
    for (String type in types) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(type),
        value: type,
      );
      items.add(item);
    }
    return items;
  }

  //generate travel mode dropdown list
  static List<DropdownMenuItem> prefTravelModeDropdownItems() {
    List<DropdownMenuItem> items = [];
    List<String> modes = TravelModes.getList;
    for (String mode in modes) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(mode),
        value: mode,
      );
      items.add(item);
    }
    return items;
  }
}

class SessionController extends Controller<SessionModel> {
  SessionController(m) : super(model: m) {
    session = SessionManager_Client.getLoadedSession;
    address1 = TextEditingController();
    address1.text = session.users[0].prefStartCoords.address;
    address2 = TextEditingController();
    address2.text = session.users[1].prefStartCoords.address;
  }
  TextEditingController address1;
  TextEditingController address2;
  final formKey = GlobalKey<FormState>();
  Session_Client session;

  bool get isMounted => mounted;

  String validate(val) {
    if (val.isEmpty) return 'This field is required';
  }

  //local memory + server update
  sendUpdatePreferredLocation(val) {
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.preferredLocationType,
      value: val,
    ).then((success) {
      if (success) updatePreferredLocation(val); //local
      else throw 'server failed to update field';
    }).catchError(model.showErrorDialog);
  }
  sendUpdateAddress1() {
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.user1Address,
      value: address1.text,
    ).then((success) {
      if (success) updateAddress1(); //local
      else throw 'server failed to update field';
    }).catchError(model.showErrorDialog);
  }
  sendUpdateAddress2() {
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.user2Address,
      value: address2.text,
    ).then((success) {
      if (success) updateAddress2(); //local
      else throw 'server failed to update field';
    }).catchError(model.showErrorDialog);
  }
  sendUpdatePreferredTravelMode1(val) {
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.user1PreferredTravelMode,
      value: val,
    ).then((success) {
      if (success) updatePreferredTravelMode1(val); //local
      else throw 'server failed to update field';
    }).catchError(model.showErrorDialog);
  }
  sendUpdatePreferredTravelMode2(val) {
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.user2PreferredTravelMode,
      value: val,
    ).then((success) {
      if (success) updatePreferredTravelMode2(val); //local
      else throw 'server failed to update field';
    }).catchError(model.showErrorDialog);
  }

  //local memory plus visual updates
  updatePreferredLocation(val) {
    session.prefLocationType = val;
    model.updatePreferredLocation(val);
  }
  updateAddress1() {
    session.users[0].prefStartCoords.address = address1.text;
  }
  updateAddress2() {
    session.users[1].prefStartCoords.address = address2.text;
  }
  updatePreferredTravelMode1(val) {
    session.users[0].prefTravelMode = val;
    model.updatePreferredTravelMode1(val);
  }
  updatePreferredTravelMode2(val) {
    session.users[1].prefTravelMode = val;
    model.updatePreferredTravelMode2(val);
  }

  //send current loaded parameters for calculation
  calcMeetpoints() {
    if (!formKey.currentState.validate()) return; //validate fields

    //ensure all text fields are updated and captured by server (covers user forgetfulness: changing and nor confirming)
    sendUpdateAddress1();
    sendUpdateAddress2();

    model.updateMapsDisplay(type: 2); //show loader text

    SessionManager_Client.calcMeetpoint() //calculate and wait for result
    .then((success) {
      if (!mounted) return;
      if (success) model.updateMapsDisplay(type: 1);
      else model.updateMapsDisplay(type: 4);
    }).catchError((error) {
      if (mounted) model.updateMapsDisplay(type: 5);
    });
  }
  //prompts delete dialog box
  promptDelete() {
    showDialog(
      context: SessionView.viewContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Deleting this session is permanent, '
                        'however other users already inside remain in the session.\n'
                        '\nAre you sure you want to delete this?'
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                //close dialog box
                Navigator.of(context).pop();
                //attempt to delete on server
                SessionManager_Client.deleteSession(sessionId: session.sessionID)
                .then((result) {
                  if (result) {
                    //navigate out of session
                    Navigator.pop(context);
                  } else {
                    throw 'Failed to delete session on server, try again later.';
                  }
                }).catchError((error) {
                  model.showErrorDialog(error);
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  }
}

class SessionModel extends Model {
  SessionModel(String sessionId) {
    //initialise session variables
    session = SessionManager_Client.loadSession(sessionId: sessionId);
    preferredLocationType = session.prefLocationType;
    preferredTravelMode1 = session.users[0].prefTravelMode;
    preferredTravelMode2 = session.users[1].prefTravelMode;
    chosenMeetpointIndex = session.chosenMeetpointIndex;
    //initial maps display
    if (session.meetpoints.length == 0) {
      mapsDisplay = blankMapsDisplay(
        icon: Icons.add_circle,
        text: 'Currently no meetpoints, key in parameters',
      );
    } else {
      mapsDisplay = pagedMapsDisplay();
    }
  }
  Session_Client session;
  String preferredLocationType = LocationTypes.getList[0];
  String preferredTravelMode1;
  String preferredTravelMode2;
  Widget mapsDisplay;
  int chosenMeetpointIndex;

  //boolean getter to see if screen is in view
  bool get isMounted => mounted;

  //local visual updates
  updatePreferredLocation(val) {
    setViewState(() => preferredLocationType = val);
  }
  updatePreferredTravelMode1(val) {
    setViewState(() => preferredTravelMode1 = val);
  }
  updatePreferredTravelMode2(val) {
    setViewState(() => preferredTravelMode2 = val);
  }
  updateChosenMeetpoint(val) {
    //send update
    SessionManager_Client.requestSessionEdit(
      sessionId: session.sessionID,
      field: Field.chosenMeetpoint,
      value: val.toString(),
    ).then((success) {
      if (!success) throw 'server failed to update field';
      //set chosen meetpoint
      session.chosenMeetpoint = session.meetpoints[val];
      //reflect on home page
      HomeView.refresh = true;
      //update view
      setViewState(() {
        chosenMeetpointIndex = val;
        mapsDisplay = pagedMapsDisplay();
      });
    }).catchError(showErrorDialog);
  }

  //update to proper state
  updateMapsDisplay({@required int type}) {
    setViewState(() {
      switch(type) {
        case 1: //loaded maps display
          chosenMeetpointIndex = 0;
          mapsDisplay = pagedMapsDisplay();
          break;
        case 2: //calculating...
          mapsDisplay = blankMapsDisplay(icon: Icons.search, text: 'Calculating your Meetpoints...',);
          break;
        case 3: //not enough params
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'Not enough parameters.',);
          break;
        case 4: //no meetpoint found
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'No meetpoint found.',);
          break;
        case 5: //could not connect
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'Connection to server has an issue.',);
          break;
      }
    });
  }

  //builds a blank display with chosen text
  Widget blankMapsDisplay({
    @required IconData icon,
    @required String text,
  }) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: Icon(icon),
          ),
          Text(text),
        ],
      ),
    );
  }

  //builds the scrollable consisting of single map displays
  Widget pagedMapsDisplay() {
    List<Meetpoint_Client> meetpoints = session.meetpoints;
    List<Widget> mapPages = [];
    int index = 0;
    for (Meetpoint_Client meetpoint in meetpoints) {
      Widget mapPage = singleMapDisplay(
        mapTitleBar: mapTitleBar(
          name: meetpoint.name,
          index: index,
        ),
        mapImage: mapImage(
          url: meetpoint.routeImage,
        ),
        index: index++,
      );
      mapPages.add(mapPage);
    }
    return PageView(
      children: mapPages,
    );
  }

  //builds a single map display, TITLE BAR + MAP + MORE button
  Widget singleMapDisplay({
    @required Widget mapTitleBar,
    @required Widget mapImage,
    @required int index,
  }) {
    return Center(
      child: Column(
        children: <Widget>[
          mapTitleBar,
          mapImage,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton( //more button
                child: Text('more'),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => MoreSessionInfoView(MoreSessionInfoController(MoreSessionInfoModel(index))),
                  );
                  Navigator.push(SessionView.viewContext, route);
                },
              ),
              Container(width: 10.0,),
            ],
          ),
        ],
      ),
    );
  }

  //builds the title bar for a map
  Widget mapTitleBar({
    @required String name,
    @required int index,
  }) {
    return Container(
      color: Colors.white,
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left:20.0),
            child: Text(name),
          ),
          Container(
            child: Radio(
              value: index,
              groupValue: chosenMeetpointIndex,
              onChanged: updateChosenMeetpoint,
              activeColor: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  //builds one map image
  Widget mapImage({@required String url}) {
    return Container(
      color: Colors.blueGrey,
      height: 230.0,
      child: Center(
        child: Text(url),
      ),
    );
  }

  showErrorDialog(error) {
    showDialog(
      context: SessionView.viewContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: Text(error),
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