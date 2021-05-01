import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/settings/settings.dart';

import 'authentication/authentication.dart';
import 'authentication/enums/enums.dart';
import 'home/home.dart';
import 'shopping_list/shopping_list.dart';
import 'splash/splash_screen.dart';
import 'theme.dart';

/// Provides the Bloc that listens to the authentication state.
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

/// Entryway to the main UI, decides initial page from authentication bloc.
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
                if (state.user.emailIsVerified) {
                  _navigator.pushReplacementNamed(HomePage.id);
                } else {
                  _navigator.pushReplacementNamed(VerifyEmailPage.id);
                }
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushReplacementNamed(LoginPage.id);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      routes: {
        HomePage.id: (_) => HomePage(),
        ListSettingsPage.id: (_) => ListSettingsPage(),
        LoginPage.id: (_) => LoginPage(),
        SettingsPage.id: (_) => SettingsPage(),
        SignUpPage.id: (_) => SignUpPage(),
        SplashPage.id: (_) => SplashPage(),
        VerifyEmailPage.id: (_) => VerifyEmailPage(),
      },
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => SplashPage(),
      ),
    );
  }
}
