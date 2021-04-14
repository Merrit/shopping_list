import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/splash/splash.dart';
import 'package:shopping_list/theme.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:logging/logging.dart';
// import 'package:money2/money2.dart';
// import 'package:shopping_list/preferences/preferences.dart';

// class App extends ChangeNotifier {
//   final Currency currency;
//   String? currentListId;
//   User? user;
//   final Logger _log;

//   App._singleton()
//       : currency = Currency.create('USD', 2),
//         _log = Logger('App') {
//     _log.info('Initialized');
//   }

//   static final App instance = App._singleton();

//   /// Populate the inital data the app will need.
//   Future<void> init() async {
//     // await _setEmulator();  // Enable to use local Firebase emulator.
//     await Preferences.instance.initPrefs();
//     await _setCurrentList();
//   }

//   /// Populate [currentListId] on app startup.
//   Future<void> _setCurrentList() async {
//     currentListId = Preferences.instance.lastUsedListName();
//     _log.info('lastUsedListName: $currentListId');
//   }
// }
