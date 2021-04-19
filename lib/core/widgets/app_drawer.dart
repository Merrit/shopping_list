import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';

import '../core.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Drawer(
      child: SingleChildScrollViewWithExpanded(
        children: [
          Text(user.email),
        ],
      ),
    );
  }
}
