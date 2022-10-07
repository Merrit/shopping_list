import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/authentication/bloc/authentication_bloc.dart';
import 'application/home/cubit/home_cubit.dart';
import 'application/shopping_list/cubit/shopping_list_cubit.dart';
import 'domain/authentication/authentication.dart';
import 'infrastructure/authentication_repository/authentication_repository.dart';
import 'infrastructure/preferences/preferences_repository.dart';
import 'infrastructure/shopping_list_repository/shopping_list_repository.dart';
import 'presentation/home/pages/home_page.dart';
import 'presentation/login/login.dart';
import 'presentation/settings/settings.dart';
import 'presentation/shopping_list/pages/list_settings_page.dart';
import 'presentation/splash/splash.dart';
import 'shortcuts/app_shortcuts.dart';
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
        child: const AppView(),
      ),
    );
  }
}

/// Entryway to the main UI, decides initial page from authentication bloc.
class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  AppViewState createState() => AppViewState();
}

class AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.unauthenticated:
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.dark,
              routes: {
                LoginPage.id: (_) => const LoginPage(),
                SignUpPage.id: (_) => const SignUpPage(),
              },
              onGenerateRoute: (RouteSettings routeSettings) {
                return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    Widget child;
                    switch (routeSettings.name) {
                      case LoginPage.id:
                        child = const LoginPage();
                        break;
                      case SignUpPage.id:
                        child = const SignUpPage();
                        break;
                      case VerifyEmailPage.id:
                        child = const VerifyEmailPage();
                        break;
                      default:
                        child = const LoginPage();
                    }

                    return child;
                  },
                );
              },
              home: const LoginPage(),
            );

          case AuthenticationStatus.authenticated:
            final homeCubit = HomeCubit(
              PreferencesRepository(),
              shoppingListRepository: FirebaseShoppingListRepository(
                state.user.id,
              ),
              user: state.user,
            );

            // BlocProviders above MaterialApp so they are accessible from all
            // contexts and do not need to be passed manually.
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: homeCubit),
                BlocProvider(
                  create: (context) => ShoppingListCubit(homeCubit: homeCubit),
                  child: Container(),
                )
              ],
              child: AppShortcuts(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.dark,
                  navigatorKey: _navigatorKey,
                  routes: {
                    HomePage.id: (_) => const HomePage(),
                    ListSettingsPage.id: (_) => const ListSettingsPage(),
                    SettingsPage.id: (_) => const SettingsPage(),
                    SplashPage.id: (_) => const SplashPage(),
                    VerifyEmailPage.id: (_) => const VerifyEmailPage(),
                  },
                  onGenerateRoute: (RouteSettings routeSettings) {
                    return MaterialPageRoute<void>(
                      settings: routeSettings,
                      builder: (BuildContext context) {
                        Widget child;
                        switch (routeSettings.name) {
                          case HomePage.id:
                            child = const HomePage();
                            break;
                          case ListSettingsPage.id:
                            child = const ListSettingsPage();
                            break;
                          case LoginPage.id:
                            child = const LoginPage();
                            break;
                          case SettingsPage.id:
                            child = const SettingsPage();
                            break;
                          case SignUpPage.id:
                            child = const SignUpPage();
                            break;
                          case SplashPage.id:
                            child = const SplashPage();
                            break;
                          case VerifyEmailPage.id:
                            child = const VerifyEmailPage();
                            break;
                          default:
                            child = const SplashPage();
                        }

                        return child;
                      },
                    );
                  },
                ),
              ),
            );
          default:
            throw Exception('Should be either authentication or not.');
        }
      },
    );
  }
}
