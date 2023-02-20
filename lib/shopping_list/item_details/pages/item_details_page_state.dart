import 'package:flutter/foundation.dart';

class ItemDetailsPageState extends ChangeNotifier {
  String _subpage = '';

  String get subpage => _subpage;

  set subpage(String value) {
    _subpage = value;
    notifyListeners();
  }
}
