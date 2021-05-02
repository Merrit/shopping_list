import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shopping_list.dart';

class ChooseLabelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();
    final shoppingCubit = context.read<ShoppingListCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Labels'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 15,
                  children: state.labels
                      .map(
                        (label) =>
                            BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                          builder: (context, itemDetailsState) {
                            return FilterChip(
                              selected:
                                  itemDetailsState.labels.contains(label.name),
                              label: Text(label.name),
                              onSelected: (_) {
                                itemDetailsCubit.toggleLabel(label.name);
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: shoppingCubit,
                  child: EditLabelsPage(),
                );
              },
            ),
          );
        },
        label: Text('Edit labels'),
      ),
    );
  }
}

class EditLabelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.read<ShoppingListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Labels'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            return Wrap(
              spacing: 10,
              children: state.labels
                  .map(
                    (label) => Chip(
                      label: Text(label.name),
                      onDeleted: () => shoppingCubit.deleteLabel(label),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newLabel = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: shoppingCubit,
                  child: CreateTagPage(),
                );
              },
            ),
          );
          if (newLabel != null) shoppingCubit.addLabel(name: newLabel);
        },
        label: Text('New label'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class CreateTagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    Future<bool> _onWillPop() async {
      final newLabel = _controller.value.text;
      Navigator.pop(context, newLabel);
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create label'),
          actions: [
            IconButton(
              onPressed: () => _onWillPop(),
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Label name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
