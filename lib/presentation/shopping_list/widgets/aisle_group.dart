import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
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
      onTap: () => goToItemDetails(context: context, item: item),
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
    return SizedBox(
      width: 60,
      child: Row(
        children: [
          const Spacer(),
          Text(item.quantity),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.total != '0.00') _TotalPrice(item: item),
            if (item.labels.isNotEmpty) _Labels(item: item),
            if (item.notes != '') _Notes(item: item),
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
    return Text(
      item.notes,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }
}
