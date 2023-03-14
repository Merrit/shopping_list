import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../domain/core/core.dart';
import '../shopping_list.dart';

class AisleGroup extends StatelessWidget {
  final Aisle aisle;

  const AisleGroup({
    Key? key,
    required this.aisle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        final items = shoppingListState.items
            .where((item) =>
                (item.aisle == aisle.name) && (item.isComplete == false))
            .toList();
        if (items.isEmpty) return Container();
        return Column(
          children: [
            if (aisle.name != 'None')
              Text(
                aisle.name,
                style: TextStyles.headline1.copyWith(
                  color: Color(
                    (aisle.color == 0)
                        ? 4294967295 // Default to white text if not custom.
                        : aisle.color,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(aisle.color).withOpacity(0.3),
                      blurRadius: 6.0,
                      spreadRadius: 0.0,
                      offset: const Offset(0.0, 3.0),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider(height: 0);
                    },
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ItemTile(key: ValueKey(item), item: item);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Item item;

  const _ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  bool get isLabelsEmpty {
    bool empty;
    if (item.onSale || item.buyWhenOnSale) {
      empty = false;
    } else {
      empty = true;
    }
    return empty;
  }

  bool get isNotesEmpty => item.notes == '';
  bool get isPriceUnset => item.price == '0.00';

  bool get isThreeLine {
    int result = 0;
    if (!isLabelsEmpty) result++;
    if (!isNotesEmpty) result++;
    if (!isPriceUnset) result++;
    return (result > 1) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _Quantity(item: item),
      title: Text(item.name),
      trailing: _Checkbox(item: item),
      isThreeLine: isThreeLine,
      subtitle: (hideSubtitle) ? null : _Subtitle(item: item),
      onTap: () => goToItemDetails(
        navigator: Navigator.of(context),
        item: item,
      ),
    );
  }

  bool get hideSubtitle => (isLabelsEmpty && isNotesEmpty && isPriceUnset);
}

class _Quantity extends StatelessWidget {
  const _Quantity({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  /// Returns a color for the quantity text based on the quantity.
  ///
  /// If the quantity is 1, the return value is null.
  Color? getQuantityColor() {
    if (item.quantity == '1') return null;
    final int quantity = int.parse(item.quantity);
    switch (quantity) {
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity = Text(
      item.quantity,
      style: TextStyle(color: getQuantityColor()),
    );

    final Widget quantityUnit = (item.quantityUnit != null)
        ? Text(
            item.quantityUnit!,
            style: TextStyle(color: getQuantityColor()),
          )
        : const SizedBox();

    return SizedBox(
      width: 70,
      child: Row(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              quantity,
              quantityUnit,
            ],
          ),
          const Spacer(),
          const SizedBox(width: 8),
          const VerticalDivider(),
        ],
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final shoppingListCubit = context.read<ShoppingListCubit>();
        return CheckboxLarge(
          value: state.checkedItems.contains(item),
          onChanged: (_) => shoppingListCubit.toggleItemChecked(item),
        );
      },
    );
  }
}

class _Subtitle extends StatelessWidget {
  final Item item;

  const _Subtitle({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final Widget totalPrice = (item.total != '0.00') //
            ? _TotalPrice(item: item)
            : const SizedBox();

        final Widget labels = _Labels(item: item);

        final Widget notes = (item.notes != '') //
            ? _Notes(item: item)
            : const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            totalPrice,
            labels,
            notes,
          ],
        );
      },
    );
  }
}

class _TotalPrice extends StatelessWidget {
  final Item item;

  const _TotalPrice({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        '\$${item.total}',
        style: TextStyle(color: Colors.green.withOpacity(0.8)),
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = [];

    if (item.onSale) {
      chips.add(
        Chip(
          label: const Text('SALE'),
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }

    if (item.buyWhenOnSale) {
      chips.add(
        const Chip(
          label: Text('Buy when on sale'),
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.blue,
        ),
      );
    }

    if (item.haveCoupon) {
      chips.add(
        const Chip(
          label: Text('Have coupon'),
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 5,
      runSpacing: -10,
      children: chips,
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Text(
      item.notes,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }
}
