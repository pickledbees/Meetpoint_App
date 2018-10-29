abstract class LocationTypes {
  static List<String> _list = [
    'No Preference',
    'Hospital',
    'Library',
    'Office',
    'Park',
    'Restaurant',
  ];

  static List<String> get getList => _list;
  static set setList(List<String> l) => _list = l;
}