import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/item_details/cubit/item_details_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../core/core.dart';
import '../../home/pages/home_page.dart';
import '../../settings/settings.dart';
import '../../shopping_list/pages/shopping_list_view.dart';
import 'aisles_page.dart';
import 'item_details_page.dart';
import 'item_details_page_state.dart';
import 'labels_page.dart';
import 'parent_list_page.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      builder: (context, state) {
        final itemDetailsCubit = context.read<ItemDetailsCubit>();
        final shoppingCubit = context.watch<ShoppingListCubit>();
        final mediaQuery = MediaQuery.of(context);
        final isWide = (mediaQuery.size.width > 600);
        final listPadding = (isWide)
            ? const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              )
            : const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              );
        final items = [
          ListTile(
            leading: const Icon(Icons.title),
            title: const Text('Name'),
            subtitle: Text(state.name),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Name',
                initialValue: state.name,
                preselectText: true,
              );
              if (input != null) {
                itemDetailsCubit.updateItem(name: input.capitalizeFirst);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('Quantity'),
            subtitle: Text(state.quantity),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Quantity',
                type: InputDialogs.onlyInt,
                initialValue: state.quantity,
                preselectText: true,
              );
              if (input != null) itemDetailsCubit.updateItem(quantity: input);
            },
          ),
          const AisleTile(),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Price'),
            subtitle: Text(state.price),
            onTap: () async {
              final input = await InputDialog.show(
                  context: context,
                  title: 'Price',
                  type: InputDialogs.onlyDouble,
                  initialValue: state.price,
                  preselectText: true);
              if (input != null) itemDetailsCubit.updateItem(price: input);
            },
          ),
          InkWell(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider.value(
                      value: homeCubit,
                      child: const SettingsPage(),
                    );
                  },
                ),
              );
            },
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                return SwitchListTile(
                  secondary: const Icon(Icons.calculate_outlined),
                  title: const Text('Tax'),
                  value: state.hasTax,
                  subtitle: (state.hasTax && !homeState.taxRateIsSet)
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () async {
                              final input = await InputDialog.show(
                                context: context,
                                title: 'Enter tax rate',
                                autofocus: true,
                                initialValue: homeState.taxRate,
                                preselectText: true,
                                type: InputDialogs.onlyDouble,
                              );
                              if (input == null) return;
                              homeCubit.updateTaxRate(input);
                            },
                            child: const Text(
                              'Set tax rate',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        )
                      : null,
                  onChanged: (value) =>
                      itemDetailsCubit.updateItem(hasTax: value),
                );
              },
            ),
          ),
          const LabelsTile(),
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('Notes'),
            subtitle: (state.notes == '') ? null : Text(state.notes),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Notes',
                initialValue: state.notes,
                type: InputDialogs.multiLine,
              );
              if (input != null) {
                itemDetailsCubit.updateItem(notes: input.capitalizeFirst);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('List'),
            subtitle: Text(shoppingCubit.state.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: homeCubit),
                        BlocProvider.value(value: shoppingCubit),
                      ],
                      child: ParentListPage(itemName: state.name),
                    );
                  },
                ),
              );
            },
          ),
        ];

        return ListView.separated(
          padding: listPadding,
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        );
      },
    );
  }
}

class AisleTile extends StatelessWidget {
  const AisleTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.watch<ShoppingListCubit>();

    return ListTile(
      leading: const Icon(Icons.format_color_text),
      title: Row(
        children: [
          const Text('Aisle'),
          const SizedBox(width: 15),
          BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
            builder: (context, state) {
              final aisleFromList = shoppingCubit.state.aisles
                  .firstWhereOrNull((aisle) => aisle.name == state.aisle);
              final backgroundColor =
                  (aisleFromList == null) ? null : Color(aisleFromList.color);

              return Chip(
                label: Text(state.aisle),
                backgroundColor: backgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ),
        ],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () => _goToSubPage(context, pageId: AislesPage.id),
    );
  }
}

class LabelsTile extends StatelessWidget {
  const LabelsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.label),
          title: const Text('Labels'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          subtitle: (state.labels.isEmpty)
              ? null
              : BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: itemDetailsCubit.state.labels
                            .map(
                              (label) => Text(
                                label,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Color(
                                        shoppingListCubit.state.labels
                                            .firstWhere(
                                              (element) =>
                                                  element.name == label,
                                              orElse: () => Label(
                                                name: label,
                                                color: Colors.white.value,
                                              ),
                                            )
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
          onTap: () => _goToSubPage(context, pageId: LabelsPage.id),
        );
      },
    );
  }
}

void _goToSubPage(BuildContext context, {required String pageId}) {
  final isWide = isLargeFormFactor(context);
  if (isWide) {
    final state = context.read<ItemDetailsPageState>();
    state.subpage = pageId;
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: itemDetailsCubit),
              BlocProvider.value(value: shoppingListCubit),
            ],
            child: (pageId == AislesPage.id)
                ? const AislesPage()
                : const LabelsPage(),
          );
        },
      ),
    );
  }
}
