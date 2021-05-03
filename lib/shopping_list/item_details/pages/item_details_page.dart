import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import 'package:shopping_list/core/widgets/text_input_formatter.dart';

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

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              hintText: itemDetailsCubit.state.name,
              onChanged: (value) => itemDetailsCubit.updateName(value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Quantity'),
              hintText: state.quantity,
              onChanged: (value) => itemDetailsCubit.updateQuantity(value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: Text('Aisle'),
              onChanged: (value) => itemDetailsCubit.updateAisle(value),
              child: ActionChip(
                label: Text(
                  _verifyAisle(
                    shoppingCubit: shoppingCubit,
                    aisle: state.aisle,
                  ),
                ),
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
              hintText: state.price,
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => itemDetailsCubit.updatePrice(value),
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
                        await Navigator.pushNamed(
                          context,
                          SettingsPage.id,
                        );
                        shoppingCubit.updateTaxRate();
                      },
                      child: Text('Set tax rate'),
                    ),
                  Switch(
                    value: state.hasTax,
                    onChanged: (value) => itemDetailsCubit.updateHasTax(value),
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
              onChanged: (value) => itemDetailsCubit.updateNotes(value),
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
