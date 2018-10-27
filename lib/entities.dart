Map<String,User> Users = {
  'identifier' : User(),
};

//new entity class
class User {
  UserDetails userDetails = UserDetails();
  SessionsLog sessionsLog;
}

class UserDetails {
  String name;
  Location prefStartCoords = Location();
  String prefTravelMode;
}

class Location {
  String name,type,address; //add address
  List<double> coordinates = []; //may want to remove
}

class SessionsLog {
  List<Session> sessions = [];

  int get getNumSessions => sessions.length;

  List<String> get getSessionNames {
    List<String> names = [];
    for (Session session in sessions) names.add(session.title);
    return names;
  }

  List<Meetpoint> get getChosenMeetpoints {
    List<Meetpoint> meetpoints = [];
    for (Session session in sessions) meetpoints.add(session.chosenMeetpoint);
  }
}

class Session {
  Session(this.sessionID,this.title);

  final String sessionID;
  final String title;
  List<Meetpoint> meetpoints = [];
  Meetpoint chosenMeetpoint = Meetpoint();
  String prefLocationType;
  List<UserDetails> users = [];
  double timeCreated;

  int get getNumMeetpoints {
    return null;
  }
}

class Meetpoint extends Location {
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


