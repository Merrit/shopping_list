import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/settings/settings.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons();

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationBloc>();
    final homeCubit = context.read<HomeCubit>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _auth.add(AuthenticationLogoutRequested()),
            child: Text('Sign out'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider.value(
                      value: homeCubit,
                      child: SettingsPage(),
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}
