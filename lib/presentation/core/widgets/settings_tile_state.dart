import 'package:flutter/foundation.dart';

class SettingsTileState extends ChangeNotifier {
  bool hasChanged = false;

  void setChanged(bool value) {
    if (hasChanged == true && value == true) {
      return;
    } else {
      hasChanged = value;
      notifyListeners();
    }
  }
}
