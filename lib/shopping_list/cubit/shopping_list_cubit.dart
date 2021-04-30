import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  final HomeCubit _homeCubit;
  late StreamSubscription _homeCubitSubscription;
  late ShoppingList _shoppingList;
  final ShoppingListRepository _shoppingListRepository;

  ShoppingListCubit({
    required HomeCubit homeCubit,
  })  : _homeCubit = homeCubit,
        _shoppingList = ShoppingList(name: '', owner: homeCubit.user.id),
        _shoppingListRepository = homeCubit.shoppingListRepository,
        super(ShoppingListState.initial()) {
    final currentListId = homeCubit.state.currentListId;
    if (currentListId != '') {
      final shoppingList = homeCubit.state.shoppingLists
          .firstWhere((element) => element.id == currentListId);
      _listChanged(shoppingList);
    }
    _listenToHomeCubit(homeCubit);
  }

  SharedPreferences? prefs;

  void _listenToHomeCubit(HomeCubit homeCubit) {
    _homeCubitSubscription = homeCubit.stream.listen((HomeState event) {
      final currentList = event.shoppingLists.firstWhereOrNull(
        (list) => list.id == event.currentListId,
      );
      if (currentList != null && currentList != _shoppingList) {
        _listChanged(currentList);
      }
      if (prefs == null && (event.prefs != null)) {
        prefs = event.prefs;
        updateTaxRate();
      }
    });
  }

  void _listChanged(ShoppingList list) {
    _shoppingList = list;
    emit(state.copyWith(
      name: list.name,
      aisles: list.aisles,
      items: list.items,
    ));
  }

  void _updateList(ShoppingList list) {
    _shoppingListRepository.updateShoppingList(list);
  }

  void updateListName(String value) {
    _updateList(
      _shoppingList.copyWith(name: value),
    );
  }

  void deleteList() {
    _shoppingListRepository.deleteShoppingList(_shoppingList);
  }

  void createItem({
    required String name,
  }) {
    final newItem = Item(name: name);
    _shoppingList.items.add(newItem);
    _shoppingListRepository.updateShoppingList(_shoppingList);
  }

  void updateItem({required Item oldItem, required Item newItem}) {
    _shoppingList.items.remove(oldItem);
    _shoppingList.items.add(newItem);
    _shoppingListRepository.updateShoppingList(_shoppingList);
  }

  void deleteItem(Item item) {
    _shoppingList.items.removeWhere((element) => element == item);
    _shoppingListRepository.updateShoppingList(_shoppingList);
  }

  void toggleItemChecked(Item item) {
    final isChecked = state.checkedItems.contains(item);
    if (isChecked) {
      state.checkedItems.remove(item);
    } else {
      state.checkedItems.add(item);
    }
    emit(state.copyWith());
  }

  void toggleAllItemsChecked() {
    final anyAreChecked = state.checkedItems.isNotEmpty;
    if (anyAreChecked) {
      state.checkedItems.clear();
    } else {
      state.checkedItems.clear();
      state.checkedItems.addAll(state.items);
    }
    emit(state.copyWith());
  }

  void setCheckedItemsCompleted() {
    final changedItems = <Item>[];
    state.checkedItems.forEach(
      (item) {
        changedItems.add(item.copyWith(isComplete: true));
        _shoppingList.items.remove(item);
      },
    );
    state.checkedItems.clear();
    _shoppingList.items.addAll(changedItems);
    _updateList(_shoppingList);
  }

  void deleteCompletedItems() {
    _shoppingList.items.removeWhere((item) => item.isComplete);
    _updateList(_shoppingList);
  }

  void createAisle({required String name, String? color}) {
    _shoppingList.aisles.add(Aisle(name: name));
    _updateList(_shoppingList);
  }

  String verifyAisle({required String aisle}) {
    if (aisle == 'None') return '';
    final aisleExists = (state.aisles.any(
      (element) => element.name == aisle,
    ));
    if (aisleExists) {
      return aisle;
    } else {
      return '';
    }
  }

  void deleteAisle({required Aisle aisle}) {
    _shoppingList.aisles.remove(aisle);
    // final updatedItems = _removeDeletedAisle(aisle.name);
    // _updateList(_shoppingList.copyWith(items: updatedItems));
    _updateList(_shoppingList);
  }

  // List<Item> _removeDeletedAisle(String deletedAisle) {
  //   final items = <Item>[];
  //   _shoppingList.items.forEach((item) {
  //     if (item.aisle == deletedAisle) {
  //       items.add(item.copyWith(aisle: 'None'));
  //     } else {
  //       items.add(item);
  //     }
  //   });
  //   return items;
  // }

  String updateTaxRate() {
    final taxRate = _homeCubit.state.prefs!.getString('taxRate') ?? '0.0';
    emit(state.copyWith(taxRate: taxRate));
    return taxRate;
  }

  @override
  Future<void> close() {
    _homeCubitSubscription.cancel();
    return super.close();
  }
}
