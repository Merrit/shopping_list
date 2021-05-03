import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/core/helpers/money_handler.dart';
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
    homeCubit.updateShoppingListCubit(this);
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
      labels: list.labels,
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
    final updatedTotal = MoneyHandler().totalPrice(
      price: newItem.price,
      quantity: newItem.quantity,
      taxRate: (newItem.hasTax) ? taxRate : null,
    );
    _shoppingList.items.add(newItem.copyWith(total: updatedTotal));
    _shoppingListRepository.updateShoppingList(_shoppingList);
  }

  void setItemNotCompleted(Item item) {
    _shoppingList.items.remove(item);
    _shoppingList.items.add(item.copyWith(isComplete: false));
    _updateList(_shoppingList);
    emit(state.copyWith(items: _shoppingList.items));
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

  void updateTableSorting({
    required bool ascending,
    required int columnIndex,
    required String sortBy,
  }) {
    final sortedItems = ItemSorter().sort(
      ascending: ascending,
      currentItems: _shoppingList.items,
      sortBy: sortBy,
    );
    _updateList(_shoppingList.copyWith(items: sortedItems));
    emit(state.copyWith(
      items: sortedItems,
      columnSortIndex: columnIndex,
      sortAscending: ascending,
    ));
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

  String get taxRate => _homeCubit.state.prefs!.getString('taxRate') ?? '0.0';

  void updateTaxRate() {
    emit(state.copyWith(taxRate: taxRate));
  }

  void addLabel({required String name, String color = ''}) {
    final newLabel = Label(name: name, color: color);
    _shoppingList.labels.add(newLabel);
    _updateList(_shoppingList);
    emit(state.copyWith(labels: _shoppingList.labels));
  }

  void deleteLabel(Label label) {
    _shoppingList.labels.remove(label);
    _updateList(_shoppingList);
    emit(state.copyWith(labels: _shoppingList.labels));
  }

  @override
  Future<void> close() {
    _homeCubitSubscription.cancel();
    return super.close();
  }
}
