abstract class TravelModes {
  static List<String> _list = [
    'No Preference',
    'Car',
    'Walking',
    'Public Transport',
  ];

  static List<String> get getList => _list;
  static set setList(List<String> l) => _list = l;
}