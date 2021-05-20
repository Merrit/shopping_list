import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../../item_details.dart';

class LabelsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(Icons.label),
          title: Text('Labels'),
          trailing: Icon(Icons.keyboard_arrow_right),
          subtitle: (state.labels.isEmpty)
              ? null
              : BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: state.labels
                            .map(
                              (label) => Text(
                                label,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Color(
                                        shoppingListCubit.state.labels
                                            .firstWhere((element) =>
                                                element.name == label)
                                            .color,
                                      ),
                                    ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
          onTap: () => _goToLabelsPage(context),
        );
      },
    );
  }

  void _goToLabelsPage(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width > 600;
    if (isWide) {
      final state = context.read<DetailsPageState>();
      state.subpage = LabelsPage.id;
    } else {
      final itemDetailsCubit = context.read<ItemDetailsCubit>();
      final shoppingListCubit = context.read<ShoppingListCubit>();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: itemDetailsCubit),
                BlocProvider.value(value: shoppingListCubit),
              ],
              child: LabelsPage(),
            );
          },
        ),
      );
    }
  }
}
