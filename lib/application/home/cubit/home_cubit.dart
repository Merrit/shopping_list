import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/domain/core/core.dart';
import 'package:shopping_list/infrastructure/preferences/preferences_repository.dart';
import 'package:shopping_list/repositories/authentication_repository/repository.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ShoppingListRepository shoppingListRepository;
  late StreamSubscription shoppingListSubscription;
  final User user;
  final PreferencesRepository _preferencesRepository;

  HomeCubit(
    this._preferencesRepository, {
    required this.shoppingListRepository,
    required this.user,
  }) : super(
          HomeState(shoppingViewMode: _getViewMode(_preferencesRepository)),
        ) {
    _initPrefs();
    shoppingListSubscription = shoppingListRepository
        .shoppingListsStream()
        .listen((shoppingLists) => _listsChanged(shoppingLists));
  }

  static String _getViewMode(PreferencesRepository _preferencesRepository) {
    final viewModeFromPrefs = _preferencesRepository.getKey('shoppingViewMode');
    if (viewModeFromPrefs != null) {
      return viewModeFromPrefs as String;
    } else {
      return 'Dense';
    }
  }

  Future<void> _initPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(prefs: _prefs));
  }

  void _listsChanged(List<ShoppingList> shoppingLists) {
    emit(state.copyWith(
      shoppingLists: shoppingLists,
    ));
  }

  void createList({required String? name}) {
    if (name == null || name == '') return;
    shoppingListRepository.createNewShoppingList(
      ShoppingList(
        name: name,
        aisles: [Aisle(name: 'None')],
        owner: user.id,
      ),
    );
  }

  void setCurrentList(String listId) {
    emit(state.copyWith(
      currentListId: listId,
    ));
  }

  Future<void> updateListItemTotals(String taxRate) async {
    final updater = MassListUpdater(shoppingListRepository);
    await updater.updateTotals(taxRate);
  }

  void updateShoppingListCubit(ShoppingListCubit shoppingListCubit) {
    emit(state.copyWith(shoppingListCubit: shoppingListCubit));
  }

  Future<void> moveItemToList({
    required Item item,
    required String currentListName,
    required String newListName,
  }) async {
    final oldList = state.shoppingLists.firstWhere(
      (list) => list.name == currentListName,
    );
    oldList.items.remove(item);
    await shoppingListRepository.updateShoppingList(oldList);
    final newList = state.shoppingLists.firstWhere(
      (list) => list.name == newListName,
    );
    newList.items.add(item);
    if (!newList.aisles.contains(item.aisle)) {
      newList.aisles.add(
        oldList.aisles.firstWhere((element) => element.name == item.aisle),
      );
    }
    oldList.labels.forEach((label) {
      if (!newList.labels.contains(label)) {
        newList.labels.add(label);
      }
    });
    await shoppingListRepository.updateShoppingList(newList);
  }

  void updateShoppingViewMode(String shoppingViewMode) {
    assert(shoppingViewMode == 'Dense' || shoppingViewMode == 'Spacious');
    _preferencesRepository.setString(
      key: 'shoppingViewMode',
      value: shoppingViewMode,
    );
    emit(state.copyWith(shoppingViewMode: shoppingViewMode));
  }

  @override
  Future<void> close() {
    shoppingListSubscription.cancel();
    return super.close();
  }
}

class MassListUpdater {
  final ShoppingListRepository shoppingListRepository;

  const MassListUpdater(this.shoppingListRepository);

  Future<void> updateTotals(String taxRate) async {
    final lists = await shoppingListRepository.shoppingLists();
    lists.forEach((list) async {
      await _updateListItemTotals(list: list, taxRate: taxRate);
    });
  }

  Future<void> _updateListItemTotals({
    required ShoppingList list,
    required String taxRate,
  }) async {
    final updatedItems = <Item>[];
    list.items.forEach((item) {
      final updatedTotal = MoneyHandler().totalPrice(
        price: item.price,
        quantity: item.quantity,
        taxRate: (item.hasTax) ? taxRate : null,
      );
      final updatedItem = item.copyWith(total: updatedTotal);
      updatedItems.add(updatedItem);
    });
    await shoppingListRepository.updateShoppingList(
      list.copyWith(items: updatedItems),
    );
  }
}