import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:shopping_list/application/home/cubit/home_cubit.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/domain/core/core.dart';
import 'package:shopping_list/presentation/shopping_list/pages/shopping_list_view.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/presentation/shopping_list/pages/list_settings_page.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CreateListButton(),
        const _ListNameArea(),
        const _BottomButtons(),
      ],
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
}

class _ListNameArea extends StatelessWidget {
  const _ListNameArea({
    foundation.Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTileTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        selectedTileColor: Colors.grey.withAlpha(40),
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              (previous.shoppingLists != current.shoppingLists) ||
              (previous.currentListId != current.currentListId),
          builder: (context, state) {
            return ListView(
              children: state.shoppingLists
                  .map((list) => _NameTile(list: list))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class _NameTile extends StatelessWidget {
  final ShoppingList list;

  const _NameTile({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isSelected = (state.currentListId == list.id);
        return GestureDetector(
          onSecondaryTapUp: (details) async {
            final offset = details.globalPosition;
            final left = offset.dx;
            final top = offset.dy;
            final choice = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(left, top, 100000, 0),
              items: <String>[
                'List settings',
              ]
                  .map((String choice) => PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      ))
                  .toList(),
              elevation: 8.0,
            );
            switch (choice) {
              case 'List settings':
                // TODO: Combine with AppBar method that does same.
                setCurrentList(context, list.id);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: shoppingListCubit),
                          BlocProvider.value(value: homeCubit),
                        ],
                        child: ListSettingsPage(),
                      );
                    },
                  ),
                );
                break;
              default:
                break;
            }
          },
          child: ListTile(
            selected: isSelected,
            title: Center(
              child: Text(
                list.name,
                style: TextStyles.headline1.copyWith(color: Color(list.color)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: () => setCurrentList(context, list.id),
          ),
        );
      },
    );
  }

  void setCurrentList(BuildContext context, String listId) {
    final homeCubit = context.read<HomeCubit>();
    final mediaQuery = MediaQuery.of(context);
    homeCubit.setCurrentList(listId);
    if (mediaQuery.size.width < 600) {
      Navigator.pop(context);
    }
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons();

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationBloc>();
    final homeCubit = context.read<HomeCubit>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
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
    );
  }
}
