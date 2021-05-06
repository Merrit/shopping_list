import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../shopping_list.dart';

class ScrollingShoppingList extends StatelessWidget {
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        context
            .read<ActiveListState>()
            .updateFloatingButtonVisibility(_scrollController.offset);
      });
    });

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final items = state.items.where((e) => e.isComplete == false).toList();

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(4),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 0);
          },
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                title: Row(
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: state.checkedItems.contains(item),
                        onChanged: (value) =>
                            shoppingListCubit.toggleItemChecked(item),
                      ),
                    ),
                  ],
                ),
                subtitle: (item.aisle == 'None' &&
                        item.labels.isEmpty &&
                        item.notes == '' &&
                        item.quantity == '1')
                    ? null
                    : BlocBuilder<ShoppingListCubit, ShoppingListState>(
                        builder: (context, state) {
                          // var item = state.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: (item.aisle == 'None')
                                          ? const SizedBox()
                                          : Chip(
                                              label: Text(item.aisle),
                                              backgroundColor: Color(
                                                  shoppingListCubit.state.aisles
                                                      .firstWhere((element) =>
                                                          element.name ==
                                                          item.aisle)
                                                      .color),
                                            ),
                                    ),
                                    Flexible(
                                      // child: Chip(
                                      //     label: Text('x${item.quantity}')),
                                      child: (item.quantity == '1')
                                          ? const SizedBox()
                                          : Chip(
                                              label: Text('x${item.quantity}')),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: (item.price == '0.00')
                                          ? const SizedBox()
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
                                    Flexible(
                                      child: (item.total == '0.00')
                                          ? const SizedBox()
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
                                if (item.labels.isNotEmpty)
                                  Wrap(
                                    children: item.labels
                                        .map(
                                          (label) => Chip(
                                            label: Text(label),
                                            backgroundColor: Color(
                                                shoppingListCubit
                                                    .state.labels
                                                    .firstWhere((element) =>
                                                        element.name == label)
                                                    .color),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                if (item.notes != '')
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item.notes),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                onTap: () => _goToItemDetails(context, item),
              ),
            );
          },
        );
      },
    );
  }

  final _priceSubtitleStyle = const TextStyle(
    fontSize: 15,
    color: Colors.grey,
  );
}

Future<void> _goToItemDetails(BuildContext context, Item item) async {
  final cubit = context.read<ShoppingListCubit>();
  final newItem = await Navigator.push<Item>(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: ItemDetailsPage(item: item),
      ),
    ),
  );
  if (newItem != null) {
    final cubit = context.read<ShoppingListCubit>();
    cubit.updateItem(oldItem: item, newItem: newItem);
  }
}

// class _Subtitle extends StatelessWidget {

//   final Item item;

//   const _Subtitle({Key? key, required this.item}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ShoppingListCubit, ShoppingListState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Flexible(
//                     flex: 2,
//                     child: (item.aisle == 'None')
//                         ? const SizedBox()
//                         : Chip(label: Text(item.aisle)),
//                   ),
//                   Flexible(
//                     child: Chip(label: Text('x${state.items[index].quantity}')),
//                     // child: (item.quantity == '1')
//                     //     ? const SizedBox()
//                     //     : Chip(label: Text('x${item.quantity}')),
//                   ),
//                   Spacer(),
//                   Flexible(
//                     child: (item.price == '0.00')
//                         ? const SizedBox()
//                         : Column(
//                             children: [
//                               Text('\$${item.price}'),
//                               Text(
//                                 'each',
//                                 style: _priceSubtitleStyle,
//                               ),
//                             ],
//                           ),
//                   ),
//                   Flexible(
//                     child: (item.total == '0.00')
//                         ? const SizedBox()
//                         : Column(
//                             children: [
//                               Text('\$${item.total}'),
//                               Text(
//                                 'total',
//                                 style: _priceSubtitleStyle,
//                               ),
//                             ],
//                           ),
//                   ),
//                 ],
//               ),
//               if (item.labels.isNotEmpty)
//                 Wrap(
//                   children: item.labels
//                       .map((label) => Chip(label: Text(label)))
//                       .toList(),
//                 ),
//               if (item.notes != '')
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   child: Text(item.notes),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   final _priceSubtitleStyle = const TextStyle(
//     fontSize: 15,
//     color: Colors.grey,
//   );
// }
