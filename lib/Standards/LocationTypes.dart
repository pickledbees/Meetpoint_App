abstract class LocationTypes {
  static List<String> _list = [
    'food_beverages',
    'accommodation',
    'attractions',
    'bars_clubs',
    'tour',
    'shops',
  ];

  static List<String> get getList => _list;
  static set setList(List<String> l) => _list = l;

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