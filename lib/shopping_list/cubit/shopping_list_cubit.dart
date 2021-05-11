import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  final HomeCubit _homeCubit;
  late StreamSubscription _homeCubitSubscription;
  late ShoppingList _shoppingList;
  final ShoppingListRepository _shoppingListRepository;

  ShoppingListCubit({
    required HomeCubit homeCubit,
  })  : _homeCubit = homeCubit,
        // Assign initial dummy list while loading.
        _shoppingList = ShoppingList(name: '', owner: homeCubit.user.id),
        _shoppingListRepository = homeCubit.shoppingListRepository,
        super(ShoppingListState.initial()) {
    _init();
  }

  void _init() {
    final currentListId = _homeCubit.state.currentListId;
    final realListLoaded = (currentListId != '');
    if (realListLoaded) {
      _populateRealListData(currentListId);
    }
    _homeCubit.updateShoppingListCubit(this);
    _subscribeToHomeCubit();
  }

  void _populateRealListData(String currentListId) {
    final shoppingList = _homeCubit.state.shoppingLists
        .singleWhere((element) => element.id == currentListId);
    _listUpdatedFromDatabase(shoppingList);
  }

  SharedPreferences? prefs;

  void _subscribeToHomeCubit() {
    _homeCubitSubscription = _homeCubit.stream.listen((HomeState event) {
      final currentList = event.shoppingLists.firstWhereOrNull(
        (list) => list.id == event.currentListId,
      );
      if (currentList != null && currentList != _shoppingList) {
        _listUpdatedFromDatabase(currentList);
      }
      if (prefs == null && (event.prefs != null)) {
        prefs = event.prefs;
        updateTaxRate();
      }
    });
  }

  void _listUpdatedFromDatabase(ShoppingList list) {
    final sortedList = _sortItems(list: list);
    _shoppingList = sortedList;
    _emitNewState(list: _shoppingList);
  }

  void updateList({
    List<Aisle>? aisles,
    int? color,
    List<Item>? items,
    List<Label>? labels,
    String? name,
    String? sortBy,
    bool? sortAscending,
    List<Item>? checkedItems,
  }) {
    final sortedItems = ItemSorter().sort(
      ascending: sortAscending ?? state.sortAscending,
      currentItems: items ?? state.items,
      sortBy: sortBy ?? state.sortBy,
    );
    _shoppingList = _shoppingList.copyWith(
      aisles: aisles,
      color: color,
      items: sortedItems,
      labels: labels,
      name: name,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
    _shoppingListRepository.updateShoppingList(_shoppingList);
    _emitNewState(list: _shoppingList, checkedItems: checkedItems);
  }

  void _emitNewState({
    required ShoppingList list,
    List<Item>? checkedItems,
  }) {
    emit(
      state.copyWith(
        name: list.name,
        aisles: list.aisles,
        items: list.items,
        taxRate: taxRate,
        labels: list.labels,
        checkedItems: checkedItems,
        sortBy: list.sortBy,
        sortAscending: list.sortAscending,
        color: list.color,
      ),
    );
  }

  void deleteList() {
    _shoppingListRepository.deleteShoppingList(_shoppingList);
  }

  void createItem({required String name}) {
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
    final itemWithUpdatedTotal = newItem.copyWith(total: updatedTotal);
    _shoppingList.items.add(itemWithUpdatedTotal);
    updateList(items: _shoppingList.items);
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
    final noItemsChecked = state.checkedItems.isEmpty;
    state.checkedItems.clear();
    if (noItemsChecked) state.checkedItems.addAll(state.items);
    emit(state.copyWith());
  }

  void setCheckedItemsCompleted() {
    final completedItems = <Item>[];
    state.checkedItems.forEach(
      (item) {
        final completedItem = item.copyWith(isComplete: true);
        completedItems.add(completedItem);
        _shoppingList.items.remove(item);
      },
    );
    state.checkedItems.clear();
    _shoppingList.items.addAll(completedItems);
    updateList(items: _shoppingList.items);
  }

  void deleteCompletedItems() {
    _shoppingList.items.removeWhere((item) => item.isComplete);
    updateList(items: _shoppingList.items);
  }

  void createAisle({required String name, int? color}) {
    final aisle = Aisle(name: name, color: color ?? 0);
    _shoppingList.aisles.add(aisle);
    updateList(aisles: _shoppingList.aisles);
  }

  String verifyAisle({required String aisle}) {
    const defaultAisleName = ''; // Display empty if no aisle.
    if (aisle == 'None') return defaultAisleName;
    final aisleExists = state.aisles.any((element) => element.name == aisle);
    if (aisleExists) {
      return aisle;
    } else {
      return defaultAisleName;
    }
  }

  void deleteAisle({required Aisle aisle}) {
    _shoppingList.aisles.remove(aisle);
    updateList(aisles: _shoppingList.aisles);
  }

  ShoppingList _sortItems({
    required ShoppingList list,
    bool? sortAscending,
    String? sortBy,
  }) {
    final sortedItems = ItemSorter().sort(
      ascending: sortAscending ?? state.sortAscending,
      currentItems: list.items,
      sortBy: sortBy ?? state.sortBy,
    );
    return list.copyWith(items: sortedItems);
  }

  String get taxRate => _homeCubit.state.prefs!.getString('taxRate') ?? '0.0';

  void updateTaxRate() => emit(state.copyWith(taxRate: taxRate));

  void createLabel({required String name, int color = 0}) {
    final newLabel = Label(name: name, color: color);
    _shoppingList.labels.add(newLabel);
    updateList(labels: _shoppingList.labels);
  }

  void deleteLabel(Label label) {
    _shoppingList.labels.remove(label);
    updateList(labels: _shoppingList.labels);
  }

  void updateAisleColor({required int color, required Aisle oldAisle}) {
    final updatedAisle = oldAisle.copyWith(color: color);
    _shoppingList.aisles
      ..remove(oldAisle)
      ..add(updatedAisle);
    updateList(aisles: _shoppingList.aisles);
  }

  void updateLabelColor({required int color, required Label oldLabel}) {
    final updatedLabel = oldLabel.copyWith(color: color);
    _shoppingList.labels
      ..remove(oldLabel)
      ..add(updatedLabel);
    updateList(labels: _shoppingList.labels);
  }

  @override
  Future<void> close() {
    _homeCubitSubscription.cancel();
    return super.close();
  }
}
