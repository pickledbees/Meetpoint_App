import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';
import 'package:meetpoint/Managers/Entities.dart';
import 'package:meetpoint/Standards/TravelModes.dart';
import 'package:meetpoint/Standards/LocationTypes.dart';
import 'package:meetpoint/Screens/MoreSessionInfoView.dart';
import 'dart:async';

class SessionView extends View<SessionController> {
  SessionView(c) : super(controller: c);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(controller.model.session.title),),
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
                child: MapsView(MapsController(MapsModel(context: context))),
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
                      onChanged: controller.updatePreferredLocation,
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
                /*
                child: StreamBuilder( //to handle incoming updates
                  stream: null,
                  builder: (context,snapshot) {
                    //TODO: edit variables
                    controller.editFields('session_object_in_string_form');
                    //if preferred travel location updated, controller.updatePreferredLocation
                    //if address1 edited, addrees1 updated
                    //if address2 edited, address2 updated
                    //if preferred travel mode1 updated, controller.updatePreferredTravelMode1
                    //if preferred travle mode2 updated, controller.updatePreferredTravelMode1
                    //if new calculation, build(context); //rebuild entire page
                  },
                ),
                */
              ),
            ],
          ),
        ),
      ),
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
        child: Text('Joined:'),
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
  Stream stream; //TODO: initialise stream here-----------------------------------------------------------------
  Session_Client session;

  String validate(val) {
    if (val.isEmpty) return 'This field is required';
  }

  //TODO: implement server side stuff --------------------------------------------------------------------------
  //local memory + server update
  sendUpdatePreferredLocation(val) {
    updatePreferredLocation(val);
  }
  sendUpdateAddress1() {
    updateAddress1(); //local
  }
  sendUpdateAddress2() {
    updateAddress2(); //local
  }
  sendUpdatePreferredTravelMode1(val) {
    updatePreferredTravelMode1(val); //local
  }
  sendUpdatePreferredTravelMode2(val) {
    updatePreferredTravelMode2(val); //local
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
  updateChosenMeetpoint(val) {} //TODO: implement ------------------------------------------------------------

  //send parameters for calculation calculate ????
  calcMeetpoints() {
    //TODO: implement update session sequence-----------------------------------------------------------------
    if (formKey.currentState.validate()) print('hello');
  }

  editFields(String session_object_in_string_form) {
    //TODO: call LocalInfoManager to edit session-----------------------------------------------------------------
  }

}

class SessionModel extends Model {
  SessionModel(String sessionId) {
    //initialise session variables
    session = SessionManager_Client.loadSession(sessionId: sessionId);
    preferredLocationType = session.prefLocationType;
    preferredTravelMode1 = session.users[0].prefTravelMode;
    preferredTravelMode2 = session.users[1].prefTravelMode;
  }
  Session_Client session;
  String preferredLocationType = LocationTypes.getList[0];
  String preferredTravelMode1;
  String preferredTravelMode2;

  //local visual update
  updatePreferredLocation(val) {
    setViewState(() => preferredLocationType = val);
  }

  //local visual update
  updatePreferredTravelMode1(val) {
    setViewState(() => preferredTravelMode1 = val);
  }

  //local visual update
  updatePreferredTravelMode2(val) {
    setViewState(() => preferredTravelMode2 = val);
  }
}


//=================================================================================================================


//for nested maps view
class MapsView extends View<MapsController> {
  MapsView(c) : super(controller : c);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      height: 370.0,
      child: Column(
        children: <Widget>[
          Container(
            height: 310.0,
            color: Colors.grey,
            child: controller.model.mapsDisplay
          ),
          Container(height: 5.0,),
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
                onPressed: () => controller.calcMeetpoints, //TODO: think about how to validate-----------------
              ),
              Container(width: 10.0,),
            ],
          ),
        ],
      ),
    );
  }
}//TODO: think about how to validate----------------------------------------------------------------------


class MapsController extends Controller<MapsModel> {
  MapsController(m) : super(model : m);

  calcMeetpoints() {
    //TODO: send data using SessionManager_Client------------------------------------------------------------
    model.updateMapsDisplay(type: null); //pass in response type integer----------------!!!!!!!!!!!!
  }
}//TODO: send data using SessionManager_Client------------------------------------------------------------


class MapsModel extends Model {
  MapsModel({@required this.context}) {
    //initial value
    if (SessionManager_Client.getLoadedSession.meetpoints.length == 0) {
      mapsDisplay = blankMapsDisplay(
        icon: Icons.add_circle,
        text: 'Currently no meetpoints, key in parameters',
      );
    } else {
      mapsDisplay = pagedMapsDisplay();
    }
  }
  Widget mapsDisplay;
  BuildContext context;
  int radioGroupValue = -1;

  updateMapsDisplay({@required int type}) {
    setViewState(() {
      switch(type) {
        case 1: //loaded maps display
          mapsDisplay = pagedMapsDisplay();
          break;
        case 2: //calculating...
          mapsDisplay = blankMapsDisplay(icon: Icons.search, text: 'Calculating your Meetpoints...',);
          break;
        case 3: //not enough params
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'Not enough parameters',);
          break;
        case 4: //no meetpoint found
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'No meetpoint found',);
          break;
        case 5: //could not connect
          mapsDisplay = blankMapsDisplay(icon: Icons.warning, text: 'Not connected to server',);
          break;
      }
    });
  }

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

  Widget pagedMapsDisplay() {
    List<Meetpoint_Client> meetpoints = SessionManager_Client.getLoadedSession.meetpoints;
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
                  Navigator.push(context, route);
                },
              ),
              Container(width: 10.0,),
            ],
          ),
        ],
      ),
    );
  }

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
              groupValue: radioGroupValue,
              onChanged: (val) {
                setViewState(() {
                  radioGroupValue = val;
                  //TODO: send chosen meetpoint--------------------------------------------------
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget mapImage({@required String url}) {
    return Container(
      color: Colors.blueGrey,
      height: 230.0,
      child: Center(
        child: Text(url),
      ),
    );
  }
}