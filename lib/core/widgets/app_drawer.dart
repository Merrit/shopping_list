import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationBloc>();
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (previous.shoppingLists != current.shoppingLists) ||
          (previous.currentListId != current.currentListId),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _showCreateListDialog(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create list',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Icon(Icons.add),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: state.shoppingLists
                      .map((list) => ListNameTile(list: list))
                      .toList(),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => _auth.add(AuthenticationLogoutRequested()),
                child: Text('Sign out'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showCreateListDialog(BuildContext context) async {
  String? newListName;
  await showDialog(
    context: context,
    builder: (context) {
      final _controller = TextEditingController();
      return AlertDialog(
        title: Text('Create list'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Name',
          ),
          onSubmitted: (_) {
            print('submitted');
            newListName = _controller.value.text;
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              newListName = _controller.value.text;
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
  context.read<HomeCubit>().createList(name: newListName);
}

class ListNameTile extends StatelessWidget {
  final ShoppingList list;

  const ListNameTile({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListTile(
          leading: SizedBox(width: 1),
          selected: (state.currentListId == list.id),
          title: Text(list.name),
          onTap: () {
            context.read<HomeCubit>().setCurrentList(list.id);
            if (mediaQuery.size.width < 600) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
