import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../item_details.dart';

// ignore: must_be_immutable
class ItemDetailsPage extends StatelessWidget {
  static const id = 'item_details_page';

  Item itemForCubit;

  ItemDetailsPage({
    Key? key,
    required Item item,
  })  : itemForCubit = item,
        super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    final item = context.read<ItemDetailsCubit>().updatedItem();
    // Return the modified item.
    Navigator.pop(context, item);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemDetailsCubit(itemForCubit),
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: ItemDetailsView(),
            ),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class ItemDetailsView extends StatelessWidget {
  ItemDetailsView({
    Key? key,
  }) : super(key: key);

  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      buildWhen: (previous, current) =>
          (previous.aisle != current.aisle) ||
          (previous.hasTax != current.hasTax) ||
          (previous.labels != current.labels),
      builder: (context, state) {
        final itemDetailsCubit = context.read<ItemDetailsCubit>();
        final shoppingCubit = context.watch<ShoppingListCubit>();
        final mediaQuery = MediaQuery.of(context);
        final isWide = (mediaQuery.size.width > 600);

        return ListView(
          padding: (isWide)
              ? EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: mediaQuery.size.width / 3,
                )
              : const EdgeInsets.all(40),
          children: [
            // TODO: Create a custom `Settings` section with built-in
            // padding between items and what-not.
            SettingsTile(
              label: Text('Name'),
              defaultText: itemDetailsCubit.state.name,
              onChanged: (value) => itemDetailsCubit.updateItem(name: value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Quantity'),
              hintText: state.quantity,
              onChanged: (value) =>
                  itemDetailsCubit.updateItem(quantity: value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Aisle'),
              onChanged: (value) => itemDetailsCubit.updateItem(aisle: value),
              child: ActionChip(
                label: Text(
                  _verifyAisle(
                    shoppingCubit: shoppingCubit,
                    aisle: state.aisle,
                  ),
                ),
                backgroundColor: Color(shoppingCubit.state.aisles
                    .firstWhere((element) => element.name == state.aisle)
                    .color),
                onPressed: () => showSlideInSidePanel(
                  context: context,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<ShoppingListCubit>(),
                      ),
                      BlocProvider.value(
                        value: context.read<ItemDetailsCubit>(),
                      ),
                    ],
                    child: AisleSidePanel(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Price'),
              defaultText: state.price,
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => itemDetailsCubit.updateItem(price: value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Has Tax'),
              onChanged: (value) {},
              child: Column(
                children: [
                  if (state.hasTax &&
                      ((shoppingCubit.taxRate == '0.0') ||
                          (shoppingCubit.taxRate == '0')))
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
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
                        shoppingCubit.updateTaxRate();
                      },
                      child: Text('Set tax rate'),
                    ),
                  Switch(
                    value: state.hasTax,
                    onChanged: (value) =>
                        itemDetailsCubit.updateItem(hasTax: value),
                  ),
                ],
              ),
            ),
            _Buffer(),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 6.0,
                ),
                child: ListTile(
                  leading: Icon(Icons.label),
                  title: Text('Labels'),
                  subtitle: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                    builder: (context, state) {
                      return Wrap(
                        // spacing: 10,
                        children: state.labels
                            .map(
                              (label) => Chip(
                                label: Text(label),
                                backgroundColor: Color(shoppingCubit
                                    .state.labels
                                    .firstWhere(
                                        (element) => element.name == label)
                                    .color),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: itemDetailsCubit),
                              BlocProvider.value(value: shoppingCubit),
                            ],
                            child: ChooseLabelsPage(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Notes'),
              defaultText: state.notes,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) => itemDetailsCubit.updateItem(notes: value),
            ),
            const SizedBox(height: 40),
            DropdownButton<String>(
              value: shoppingCubit.state.name,
              items: homeCubit.state.shoppingLists
                  .map((e) => e.name)
                  .toList()
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) {
                homeCubit.moveItemToList(
                  item: shoppingCubit.state.items
                      .firstWhere((element) => element.name == state.name),
                  currentListName: shoppingCubit.state.name,
                  newListName: value!,
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _verifyAisle({
    required ShoppingListCubit shoppingCubit,
    required String aisle,
  }) {
    final verifiedAisle = (shoppingCubit.verifyAisle(aisle: aisle));
    if (verifiedAisle == '') {
      return 'None';
    } else {
      return verifiedAisle;
    }
  }
}

class _Buffer extends StatelessWidget {
  const _Buffer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 40);
  }
}
