import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:money2/money2.dart';
import 'package:shopping_list/preferences/preferences.dart';

class App extends ChangeNotifier {
  final Currency currency;
  String? currentListId;
  User? user;
  final Logger _log;

  App._singleton()
      : currency = Currency.create('USD', 2),
        _log = Logger('App') {
    _log.info('Initialized');
  }

  static final App instance = App._singleton();

  /// Populate the inital data the app will need.
  Future<void> init() async {
    // await _setEmulator();  // Enable to use local Firebase emulator.
    await Preferences.instance.initPrefs();
    await _setCurrentList();
  }

  /// Populate [currentListId] on app startup.
  Future<void> _setCurrentList() async {
    currentListId = Preferences.instance.lastUsedListName();
    _log.info('lastUsedListName: $currentListId');
  }
}
