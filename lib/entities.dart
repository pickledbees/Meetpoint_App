Map<String,User> Users = {
  'identifier' : User(),
};

//new entity class
class User {
  UserDetails_Client userDetails = UserDetails_Client();
  SessionsLog sessionsLog;
}

class UserDetails_Client {
  String name;
  Location_Client prefStartCoords = Location_Client();
  String prefTravelMode;
}

class Location_Client {
  String name,type,address; //add address
  List<double> coordinates = []; //may want to remove
}

class SessionsLog {
  List<Session_Client> sessions = [];

  int get getNumSessions => sessions.length;

  List<String> get getSessionNames {
    List<String> names = [];
    for (Session_Client session in sessions) names.add(session.title);
    return names;
  }

  List<Meetpoint_Client> get getChosenMeetpoints {
    List<Meetpoint_Client> meetpoints = [];
    for (Session_Client session in sessions) meetpoints.add(session.chosenMeetpoint);
  }
}

class Session_Client {
  Session_Client(this.sessionID,this.title);

  final String sessionID;
  final String title;
  List<Meetpoint_Client> meetpoints = [];
  Meetpoint_Client chosenMeetpoint = Meetpoint_Client();
  String prefLocationType;
  List<UserDetails_Client> users = [];
  double timeCreated;

  int get getNumMeetpoints {
    return null;
  }
}

class Meetpoint_Client extends Location_Client {
  String routeImage;
}

class TravelModes {
  static List<String> list = [
    'Car',
    'Walking',
    'Public Transport',
    'No Preference'
  ];
  static void update() {
  }
}


