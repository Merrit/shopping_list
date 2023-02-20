import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/item_details/cubit/item_details_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../infrastructure/shopping_list_repository/models/item.dart';
import '../../../presentation/core/core.dart';
import '../../../presentation/home/pages/home_page.dart';
import '../../../presentation/settings/settings.dart';
import '../../shopping_list.dart';
import 'item_details_page.dart';
import 'parent_list_page.dart';

class ItemDetailsView extends StatefulWidget {
  const ItemDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  final notesController = TextEditingController();

  @override
  void initState() {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();
    notesController.text = itemDetailsCubit.state.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, Item>(
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

        /// ListTile with an inline TextFormField that updates the item's notes.
        final Widget notesTile = ListTile(
          leading: const Icon(Icons.notes),
          title: const Text('Notes'),
          subtitle: Opacity(
            opacity: 0.7,
            child: TextFormField(
              controller: notesController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add notes',
              ),
              maxLines: null,
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) {
                itemDetailsCubit.updateItem(
                  state.copyWith(
                    notes: value,
                  ),
                );
              },
            ),
          ),
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
                itemDetailsCubit.updateItem(state.copyWith(
                  name: input.capitalizeFirst,
                ));
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
              if (input != null) {
                itemDetailsCubit.updateItem(state.copyWith(
                  quantity: input,
                ));
              }
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
              if (input != null) {
                itemDetailsCubit.updateItem(state.copyWith(
                  price: input,
                ));
              }
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
                      itemDetailsCubit.updateItem(state.copyWith(
                    hasTax: value,
                  )),
                );
              },
            ),
          ),
          const SaleSwitchTile(),
          const WhenOnSaleSwitchTile(),
          const HaveCouponSwitchTile(),
          notesTile,
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Parent List'),
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
          BlocBuilder<ItemDetailsCubit, Item>(
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
      onTap: () => _showAisleDialog(context),
    );
  }

  /// Show a dialog with a list of aisles to choose from and a button to go to
  /// the edit aisles page.
  Future<void> _showAisleDialog(BuildContext context) async {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();

    final aisle = await showDialog<String>(
      context: context,
      builder: (context) => const _ChooseAisleDialog(),
    );

    if (aisle != null) {
      itemDetailsCubit.updateItem(itemDetailsCubit.state.copyWith(
        aisle: aisle,
      ));
    } else {
      itemDetailsCubit.refresh();
    }
  }
}

/// A dialog with a list of aisles to choose from and a button to go to the edit
/// aisles page.
class _ChooseAisleDialog extends StatelessWidget {
  const _ChooseAisleDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return SimpleDialog(
          title: Row(
            children: [
              const Text('Aisle'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _goToAislesPage(context),
              ),
            ],
          ),
          children: [
            ...state.aisles.map(
              (aisle) {
                return SimpleDialogOption(
                  child: Text(
                    aisle.name,
                    style: TextStyle(
                      color: (aisle.color == 0) ? null : Color(aisle.color),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, aisle.name),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Go to the edit aisles page.
  void _goToAislesPage(BuildContext context) {
    final shoppingCubit = context.read<ShoppingListCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: homeCubit),
              BlocProvider.value(value: shoppingCubit),
            ],
            child: const AislesPage(),
          );
        },
      ),
    );
  }
}

class SaleSwitchTile extends StatelessWidget {
  const SaleSwitchTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, Item>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Sale'),
          secondary: const Icon(Icons.money_off),
          value: state.onSale,
          onChanged: (value) => itemDetailsCubit.updateItem(state.copyWith(
            onSale: value,
          )),
        );
      },
    );
  }
}

class WhenOnSaleSwitchTile extends StatelessWidget {
  const WhenOnSaleSwitchTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, Item>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Buy when on sale'),
          secondary: const Icon(Icons.question_mark),
          value: state.buyWhenOnSale,
          onChanged: (value) => itemDetailsCubit.updateItem(state.copyWith(
            buyWhenOnSale: value,
          )),
        );
      },
    );
  }
}

class HaveCouponSwitchTile extends StatelessWidget {
  const HaveCouponSwitchTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, Item>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Have coupon'),
          secondary: const Icon(Icons.card_membership),
          value: state.haveCoupon,
          onChanged: (value) => itemDetailsCubit.updateItem(state.copyWith(
            haveCoupon: value,
          )),
        );
      },
    );
  }
}
