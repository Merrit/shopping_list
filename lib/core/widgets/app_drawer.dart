import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/core/validators/validators.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CreateListButton(),
        const _ScrollingListNames(),
        const _BottomButtons(),
      ],
    );
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

class _ScrollingListNames extends StatelessWidget {
  const _ScrollingListNames({
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
              children: (foundation.kDebugMode)
                  ? state.shoppingLists
                      .map((list) => _ListNameTile(list: list))
                      .toList()
                  : state.shoppingLists
                      .where((element) => element.name != '🔧 Test List 🔧')
                      .map((list) => _ListNameTile(list: list))
                      .toList(),
            );
          },
        ),
      ),
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
    final homeCubit = context.read<HomeCubit>();
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isSelected = (state.currentListId == list.id);
        return GestureDetector(
          onSecondaryTapUp: (details) async {
            print('tapdown');
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
                _setCurrentList(context, list.id);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (_) =>
                                  ShoppingListCubit(homeCubit: homeCubit)),
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
            // title: Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Spacer(),
            //     Flexible(
            //       flex: 1,
            //       child: Text(
            //         list.name,
            //         style: Theme.of(context).textTheme.headline6!.copyWith(
            //               color: Color(list.color),
            //             ),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //     (isSelected)
            //         ? Flexible(
            //             flex: 1,
            //             child: PopupMenuButton(
            //               itemBuilder: (context) {
            //                 return <PopupMenuEntry<String>>[];
            //               },
            //               child: Icon(Icons.hot_tub),
            //             ),
            //           )
            //         : const Spacer(),
            //   ],
            // ),
            title: Center(
              child: Text(
                list.name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Color(list.color),
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // horizontalTitleGap: 0,
            // trailing: SizedBox(
            //   height: 10,
            //   width: 10,
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: Icon(Icons.more_vert),
            //   ),
            // ),
            // trailing: (isSelected)
            //     ? PopupMenuButton(
            //         itemBuilder: (context) {
            //           return <PopupMenuEntry<String>>[];
            //         },
            //         child: Icon(Icons.hot_tub),
            //       )
            //     : const SizedBox(),
            onTap: () => _setCurrentList(context, list.id),
          ),
        );
      },
    );
  }
}

void _setCurrentList(BuildContext context, String listId) {
  final homeCubit = context.read<HomeCubit>();
  final mediaQuery = MediaQuery.of(context);
  homeCubit.setCurrentList(listId);
  if (mediaQuery.size.width < 600) {
    Navigator.pop(context);
  }
}
