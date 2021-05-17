import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:shopping_list/repositories/authentication_repository/repository.dart';

import 'app.dart';
// import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  initLogger();
  // Bloc.observer = SimpleBlocObserver();
  _disableWebRightClick();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

void _disableWebRightClick() {
  document.onContextMenu.listen((event) => event.preventDefault());
}

/// Initialize the logger.
///
/// The logger will listen and print any logs statements.
void initLogger() {
  Logger.root.onRecord.listen((record) {
    var msg = '${record.level.name}: ${record.time}: '
        '${record.loggerName}: ${record.message}';
    if (record.error != null) msg += '\nError: ${record.error}';
    print(msg);
  });
}
