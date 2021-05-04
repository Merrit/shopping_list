import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../../home/home.dart';

class ShoppingListAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final _shoppingList = state.shoppingLists
            .firstWhereOrNull((list) => list.id == state.currentListId);
        return (_shoppingList == null)
            ? AppBar()
            : AppBar(
                title: Text(_shoppingList.name),
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        'Sort by',
                        'List settings',
                        'Completed items',
                      ].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    onSelected: (String choice) {
                      switch (choice) {
                        case 'Sort by':
                          _showSortBy(context: context);
                          break;
                        case 'List settings':
                          _showListSettings(context);
                          break;
                        case 'Completed items':
                          _showCompletedItems(context: context);
                          break;
                        default:
                      }
                    },
                  ),
                ],
              );
      },
    );
  }
}

void _showListSettings(BuildContext context) {
  final homeCubit = context.read<HomeCubit>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => ShoppingListCubit(homeCubit: homeCubit),
          child: ListSettingsPage(),
        );
      },
    ),
  );
}

void _showSortBy({required BuildContext context}) {
  final shoppingCubit = context.read<HomeCubit>().state.shoppingListCubit!;
  final shoppingProvider = BlocProvider.value(value: shoppingCubit);
  AdaptiveViewManager().pushView(
    context: context,
    providers: [shoppingProvider],
    page: SortByPage(),
    view: SortByView(),
  );
}

class AdaptiveViewManager {
  const AdaptiveViewManager();

  /// If on mobile pushes a new page,
  /// on larger screens it puts the new view in the sliding side panel.
  Future<Object?> pushView({
    required BuildContext context,
    required Widget page,
    required Widget view,

    /// A list of bloc or cubit [BlocProvider.value] objects that if provided,
    /// will be passed to the new route for access there.
    List<BlocProvider> providers = const [],
  }) async {
    final mediaQuery = MediaQuery.of(context);
    final isWide = (mediaQuery.size.width > 600);
    if (isWide) {
      return showSlideInSidePanel(
        context: context,
        providers: providers,
        child: view,
      );
    } else {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(providers: providers, child: page);
          },
        ),
      );
    }
  }
}

void _showCompletedItems({required BuildContext context}) {
  final shoppingCubit = context.read<HomeCubit>().state.shoppingListCubit!;
  final shoppingProvider = BlocProvider.value(value: shoppingCubit);
  AdaptiveViewManager().pushView(
    context: context,
    providers: [shoppingProvider],
    page: SortByPage(),
    view: SortByView(),
  );
}
