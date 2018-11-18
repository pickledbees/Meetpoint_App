///Holder of constants recognised by server as valid travel mode parameters for Meetpoint calculation.
abstract class TravelModes {
  static List<String> _list = [
    'driving',
    'walking',
    'transit',
  ];

  static List<String> get getList => _list;
  static set setList(List<String> l) => _list = l;

  ///Checks if a given location type is in [_list].
  static bool inList(val) {
    for (var item in _list) {
      try {
        if (val == item) return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}