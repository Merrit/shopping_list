import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'application/setup/setup.dart';
import 'firebase_options.dart';
import 'infrastructure/authentication_repository/authentication_repository.dart';
import 'infrastructure/preferences/preferences_repository.dart';
import 'logs/logging_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LoggingManager.initialize();

  // Handle platform errors not caught by Flutter.
  PlatformDispatcher.instance.onError = (error, stack) {
    log.e('Uncaught platform error', error, stack);
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  primeFonts();
  await PreferencesRepository.init();
  EquatableConfig.stringify = kDebugMode;
  setup.init();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

/// Pre-cache the fonts so there is no jank loading emoji on web.
///
/// https://github.com/flutter/flutter/issues/42586#issuecomment-541870382
void primeFonts() {
  final pb = ParagraphBuilder(ParagraphStyle(locale: window.locale));
  pb.addText('\ud83d\ude01'); // Smiley-face emoji.
  pb.build().layout(const ParagraphConstraints(width: 100));
}
