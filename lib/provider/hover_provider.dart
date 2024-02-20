import 'package:flutter/foundation.dart';

class HoverProvider with ChangeNotifier {
  List<bool> _hover = [false, false, false];
  List<bool> get hover => _hover;

  void addHoverBool(int insertAt, bool value) {
    _hover.removeAt(insertAt);
    _hover.insert(insertAt, value);

    print(_hover);
    notifyListeners();
  }
}
