import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
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
        child: Form(
          key: controller.formKey,
          child: Column(
            children: <Widget>[
              //primer bar
              Widgets.primer(),
              //id prompt
              Widgets.sessionIdPrompt(controller.model.session.sessionID),
              //users joined in session
              Widgets.usersBar([controller.model.session.users[0].name, controller.model.session.users[1].name]),
              //map display
              Container(
                height: 250.0,
                child: controller.model.mapsDisplay,
              ),
              ButtonBar(
                //alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Calculate'),
                    onPressed: controller.calcMeetpoints,
                  ),
                ],
              ),
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
                      items: Widgets.prefLocationTypeDropdownItems(),
                      onChanged: controller.updatePreferredLocation,
                    ),
                  ),
                ],
              ),
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
                            validator: controller.validate,
                            controller: controller.address1,
                            decoration: InputDecoration(
                              hintText: 'Address',
                            ),
                          ),
                          DropdownButton(
                            value: controller.model.preferredTravelMode1,
                            items: Widgets.prefTravelModeDropdownItems(),
                            onChanged: controller.updatePreferredTravelMode1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                            validator: controller.validate,
                            controller: controller.address2,
                            decoration: InputDecoration(
                              hintText: 'Address',
                            ),
                          ),
                          DropdownButton(
                            value: controller.model.preferredTravelMode2,
                            items: Widgets.prefTravelModeDropdownItems(),
                            onChanged: controller.updatePreferredTravelMode2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionController extends Controller<SessionModel> {

  SessionController(m) : super(model: m);

  //text field controllers
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String validate(val) {
    if (val.isEmpty) return 'This field is required';
  }

  updatePreferredLocation(val) {
    //update session
    model.updatePreferredLocation(val);
  }

  updatePreferredTravelMode1(val) {
    //update session
    model.updatePreferredTravelMode1(val);
  }

  updatePreferredTravelMode2(val) {
    //update session
    model.updatePreferredTravelMode2(val);
  }

  calcMeetpoints() {
    formKey.currentState.validate();
    print('hello');
  }

  moreInfo(String name) {}
}

class SessionModel extends Model {

  SessionModel(String sessionId) {
    //load session
    session = LocalSessionManager.loadSession(sessionId: sessionId);
    //initialise maps display
    mapsDisplay = Widgets.blankMapsDisplay(
      icon: Icons.warning,
      text:'Not enough parameters to calculate',);
  }

  Session session;
  String preferredLocationType = LocationTypes.getList[0];
  String preferredTravelMode1 = TravelModes.getList[0];
  String preferredTravelMode2 = TravelModes.getList[0];
  Widget mapsDisplay;

  updatePreferredLocation(val) {
    setViewState(() => preferredLocationType = val);
  }

  updatePreferredTravelMode1(val) {
    setViewState(() => preferredTravelMode1 = val);
  }

  updatePreferredTravelMode2(val) {
    setViewState(() => preferredTravelMode2 = val);
  }

  updateMapsDisplay() {}

}

//widgets to display
class Widgets {
  static Widget primer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 7.0),
      child: Text(
        'Others can join this meeting with the following session ID',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

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

  static Widget usersBar(List<String> users) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),//users row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: Icon(Icons.person),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: Text('Joined:'),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: Text(users[0]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(users[1]),
          ),
        ],
      ),
    );
  }

  static Widget blankMapsDisplay({IconData icon,String text}) {
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

  static Widget mapsDisplay() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              ],
            ),
          ),
          Container(
          color: Colors.black12,
            height: 200.0,
            child: PageView(
              children: <Widget>[
                Text('1'),
                Text('2'),
                Text('3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

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