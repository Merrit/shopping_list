import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:shopping_list/infrastructure/preferences/preferences_repository.dart';
import 'package:shopping_list/repositories/authentication_repository/repository.dart';
import 'package:shopping_list/setup/setup.dart';

import 'app.dart';

// import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  primeFonts();
  await PreferencesRepository.init();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  initLogger();
  // Bloc.observer = SimpleBlocObserver();
  setup.init();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

/// Pre-cache the fonts so there is no jank loading emoji on web.
///
/// https://github.com/flutter/flutter/issues/42586#issuecomment-541870382
void primeFonts() {
  final pb = ParagraphBuilder(ParagraphStyle(locale: window.locale));
  pb.addText('\ud83d\ude01'); // Smiley-face emoji.
  pb.build().layout(ParagraphConstraints(width: 100));
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
