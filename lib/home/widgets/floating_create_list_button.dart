import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../home.dart';

class FloatingCreateListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callback = (String name) {
      context.read<HomeCubit>().createList(name: name);
    };
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateListDialog(callback: callback);
          },
        );
      },
      label: Text('Create list'),
    );
  }
}
