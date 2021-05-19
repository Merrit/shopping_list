import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

class NameTile extends StatelessWidget {
  final ShoppingList list;

  const NameTile({
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
                setCurrentList(context, list.id);
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
            onTap: () => setCurrentList(context, list.id),
          ),
        );
      },
    );
  }
}

void setCurrentList(BuildContext context, String listId) {
  final homeCubit = context.read<HomeCubit>();
  final mediaQuery = MediaQuery.of(context);
  homeCubit.setCurrentList(listId);
  if (mediaQuery.size.width < 600) {
    Navigator.pop(context);
  }
}
