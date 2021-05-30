import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/presentation/shopping_list/pages/shopping_list_view.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/checkbox_large.dart';
import 'package:shopping_list/repositories/shopping_list_repository/models/item.dart';
import 'package:shopping_list/repositories/shopping_list_repository/models/label.dart';

class AisleGroup extends StatelessWidget {
  final int index;

  const AisleGroup({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        final aisle = shoppingListState.aisles[index];
        final items = shoppingListState.items
            .where((item) => item.aisle == aisle.name)
            .toList();
        return Column(
          children: [
            if (aisle.name != 'None')
              Text(
                aisle.name,
                style: TextStyles.headline1.copyWith(color: Color(aisle.color)),
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
                      offset: Offset(0.0, 3.0),
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
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ItemTile(item: item);
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

  bool get isLabelsEmpty => item.labels.isEmpty;
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
      onTap: () => goToItemDetails(context, item),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.quantity),
        const SizedBox(width: 8),
        VerticalDivider(),
      ],
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
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _PriceAndTotal(item: item),
              if (item.labels.isNotEmpty) _Labels(item: item),
              if (item.notes != '') _Notes(item: item),
            ],
          ),
        );
      },
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
    return Wrap(
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
      child: Text(
        item.notes,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
