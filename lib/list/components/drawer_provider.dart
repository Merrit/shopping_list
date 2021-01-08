import 'package:flutter/foundation.dart';

class DrawerProvider extends ChangeNotifier {
  bool _editingLists = false;
  get editingLists => _editingLists;
  set editingLists(bool isEditing) {
    _editingLists = isEditing;
    notifyListeners();
  }
}
