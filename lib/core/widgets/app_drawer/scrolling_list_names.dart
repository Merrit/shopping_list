import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/home/home.dart';

import 'name_tile.dart';

class ScrollingListNames extends StatelessWidget {
  const ScrollingListNames({
    foundation.Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTileTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        selectedTileColor: Colors.grey.withAlpha(40),
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              (previous.shoppingLists != current.shoppingLists) ||
              (previous.currentListId != current.currentListId),
          builder: (context, state) {
            return ListView(
              children: state.shoppingLists
                  .map((list) => NameTile(list: list))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
