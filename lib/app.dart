import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/theme.dart';

import 'splash/splash_screen.dart';

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
                if (state.user.emailIsVerified) {
                  _navigator.pushReplacementNamed(HomeScreen.id);
                } else {
                  _navigator.pushReplacementNamed(VerifyEmailScreen.id);
                }
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushReplacementNamed(LoginScreen.id);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      routes: {
        HomeScreen.id: (_) => HomeScreen(),
        LoginScreen.id: (_) => LoginScreen(),
        SignUpScreen.id: (_) => SignUpScreen(),
        SplashScreen.id: (_) => SplashScreen(),
        VerifyEmailScreen.id: (_) => VerifyEmailScreen(),
      },
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }
}
