import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/authentication/bloc/authentication_bloc.dart';

/// The settings page for the app.
class AppSettingsPage extends StatelessWidget {
  static const id = 'app_settings_page';
  static const title = 'App settings';

  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: const AppSettingsView(),
      ),
    );
  }
}

/// The settings view for the app.
class AppSettingsView extends StatelessWidget {
  const AppSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Widget darkModeTile = Card(
    //   child: BlocBuilder<SettingsCubit, SettingsState>(
    //     builder: (context, state) {
    //       return SwitchListTile(
    //         secondary: const Icon(Icons.dark_mode),
    //         title: const Text('Dark mode'),
    //         value: state.darkMode,
    //         onChanged: (value) => SettingsCubit.instance.toggleDarkMode(),
    //       );
    //     },
    //   ),
    // );

    final Widget userTile = Card(
      child: ListTile(
        title: const Text('User'),
        subtitle: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Text(state.user.email);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Confirm sign out
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Sign out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthenticationBloc>().add(
                              AuthenticationLogoutRequested(),
                            );
                      },
                      child: const Text('Sign out'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(30),
      children: [
        // darkModeTile,
        userTile,
      ],
    );
  }
}
