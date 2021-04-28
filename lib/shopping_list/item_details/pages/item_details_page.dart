import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

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
      buildWhen: (previous, current) => previous.aisle != current.aisle,
      builder: (context, state) {
        final itemDetailsCubit = context.read<ItemDetailsCubit>();
        final shoppingCubit = context.read<ShoppingListCubit>();

        return ListView(
          padding: const EdgeInsets.all(40),
          children: [
            SettingsTile(
              label: 'Name',
              hintText: itemDetailsCubit.state.name,
              onChanged: (value) => itemDetailsCubit.updateName(value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: 'Quantity',
              hintText: state.quantity,
              onChanged: (value) => itemDetailsCubit.updateQuantity(value),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              label: 'Aisle',
              hintText: '',
              onChanged: (value) => itemDetailsCubit.updateAisle(value),
              child: OutlinedButton(
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
                child: Text(
                  _verifyAisle(
                    shoppingCubit: shoppingCubit,
                    aisle: state.aisle,
                  ),
                ),
              ),
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
