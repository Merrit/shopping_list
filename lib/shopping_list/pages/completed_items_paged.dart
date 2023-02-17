import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/shopping_list/cubit/shopping_list_cubit.dart';

class CompletedItemsPage extends StatelessWidget {
  const CompletedItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed items')),
      body: const CompletedItemsView(),
    );
  }
}

class CompletedItemsView extends StatefulWidget {
  const CompletedItemsView({Key? key}) : super(key: key);

  @override
  CompletedItemsViewState createState() => CompletedItemsViewState();
}

class CompletedItemsViewState extends State<CompletedItemsView> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();

    return Stack(
      children: [
        BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            final items = state.items.where((e) => e.isComplete).toList();
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CheckboxListTile(
                  title: Center(child: Text(item.name)),
                  value: true,
                  onChanged: (_) {
                    final updatedItem = item.copyWith(isComplete: false);
                    cubit.updateItem(oldItem: item, newItem: updatedItem);
                  },
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
                  onPressed: (state.completedItems.isNotEmpty)
                      ? () async {
                          await cubit.deleteCompletedItems();
                          setState(() {});
                        }
                      : null,
                  label: const Text('Delete all completed'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
