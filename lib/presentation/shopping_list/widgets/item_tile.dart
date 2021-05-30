import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/core/core.dart';

import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/presentation/item_details/pages/item_details_page.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final _isLargeFormFactor = isLargeFormFactor(context);

    return ListTile(
      dense: _isLargeFormFactor ? false : true,
      title: _NameAndCheckbox(item: item),
      subtitle: (item.aisle == 'None' &&
              item.labels.isEmpty &&
              item.notes == '' &&
              item.quantity == '1' &&
              item.price == '0.00')
          ? null
          : _Subtitle(item: item),
      onTap: () => _goToItemDetails(context, item),
    );
  }

  Future<void> _goToItemDetails(BuildContext context, Item item) async {
    final homeCubit = context.read<HomeCubit>();
    final shoppingListCubit = context.read<ShoppingListCubit>();
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: shoppingListCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: ItemDetailsPage(item: item),
        ),
      ),
    );
    if (newItem != null) {
      final cubit = context.read<ShoppingListCubit>();
      await cubit.updateItem(oldItem: item, newItem: newItem);
    }
  }
}

class _NameAndCheckbox extends StatelessWidget {
  const _NameAndCheckbox({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            final shoppingListCubit = context.read<ShoppingListCubit>();
            return Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: state.checkedItems.contains(item),
                onChanged: (_) => shoppingListCubit.toggleItemChecked(item),
              ),
            );
          },
        ),
      ],
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
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuantityAndAisle(item: item),
              _PriceAndTotal(item: item),
              if (item.labels.isNotEmpty) _Labels(item: item),
              if (item.notes != '') _Notes(item: item),
            ],
          ),
        );
      },
    );
  }
}

class _QuantityAndAisle extends StatelessWidget {
  const _QuantityAndAisle({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Chip(
          label: Text('x${item.quantity}'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 5),
        (item.aisle != 'None')
            ? BlocBuilder<ShoppingListCubit, ShoppingListState>(
                builder: (context, state) {
                  final aisle = state.aisles.firstWhereOrNull(
                    (aisle) => aisle.name == item.aisle,
                  );
                  final backgroundColor =
                      (aisle == null) ? null : Color(aisle.color);

                  return Chip(
                    label: Text(item.aisle),
                    backgroundColor: backgroundColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
              )
            : Container(),
      ],
    );
  }
}

class _PriceAndTotal extends StatelessWidget {
  final Item item;

  const _PriceAndTotal({
    Key? key,
    required this.item,
  }) : super(key: key);

  final _priceSubtitleStyle = const TextStyle(
    fontSize: 15,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ((item.price == '0.00') && (item.total == '0.00')) ? 0 : 10,
        left: 10,
      ),
      child: Row(
        children: [
          Flexible(
            child: (item.price == '0.00')
                ? Container()
                : Column(
                    children: [
                      Text('\$${item.price}'),
                      Text(
                        'each',
                        style: _priceSubtitleStyle,
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: (item.total == '0.00')
                ? Container()
                : Column(
                    children: [
                      Text('\$${item.total}'),
                      Text(
                        'total',
                        style: _priceSubtitleStyle,
                      ),
                    ],
                  ),
          ),
        ],
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
    return Padding(
      padding: EdgeInsets.only(
        top: (item.labels.isEmpty) ? 0 : 10,
        left: 8,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: item.labels
            .map(
              (label) => BlocBuilder<ShoppingListCubit, ShoppingListState>(
                builder: (context, state) {
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Color(
                            state.labels
                                .firstWhere(
                                  (element) => element.name == label,
                                  orElse: () => Label(
                                    name: label,
                                    color: Colors.white.value,
                                  ),
                                )
                                .color,
                          ),
                        ),
                  );
                },
              ),
            )
            .toList(),
      ),
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
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        item.notes,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}