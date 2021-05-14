import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/core/validators/validators.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/settings/settings.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationBloc>();
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (previous.shoppingLists != current.shoppingLists) ||
          (previous.currentListId != current.currentListId),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const _CreateListButton(),
              Expanded(
                child: ListTileTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedTileColor: Colors.grey.withAlpha(40),
                  child: ListView(
                    children: (foundation.kDebugMode)
                        ? state.shoppingLists
                            .map((list) => _ListNameTile(list: list))
                            .toList()
                        : state.shoppingLists
                            .where((element) => element.name != 'Test List')
                            .map((list) => _ListNameTile(list: list))
                            .toList(),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _auth.add(AuthenticationLogoutRequested()),
                    child: Text('Sign out'),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider.value(
                              value: homeCubit,
                              child: SettingsPage(),
                            );
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.settings),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateListButton extends StatelessWidget {
  const _CreateListButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => _showCreateListDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create list',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Icon(Icons.add),
          ],
        ),
      ),
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
          autofocus: platformIsWebMobile(context) ? false : true,
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

class _ListNameTile extends StatelessWidget {
  final ShoppingList list;

  const _ListNameTile({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListTile(
          selected: (state.currentListId == list.id),
          title: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                list.name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Color(list.color),
                    ),
              ),
            ),
          ),
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
