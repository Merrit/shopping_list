import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../../logs/logging_manager.dart';
import '../../../presentation/home/home.dart';
import '../../home/cubit/home_cubit.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  final HomeCubit _homeCubit;
  late StreamSubscription _homeCubitSubscription;
  late ShoppingList _shoppingList;
  final ShoppingListRepository _shoppingListRepository;

  static late ShoppingListCubit instance;

  ShoppingListCubit({required HomeCubit homeCubit})
      : _homeCubit = homeCubit,
        // Assign initial dummy list while loading.
        _shoppingList = ShoppingList(name: '', owner: homeCubit.user.id),
        _shoppingListRepository = homeCubit.shoppingListRepository,
        super(ShoppingListState.initial()) {
    instance = this;
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

  void _subscribeToHomeCubit() {
    _homeCubitSubscription = _homeCubit.stream.listen((HomeState event) {
      final currentList = event.shoppingLists.firstWhereOrNull(
        (list) => list.id == event.currentListId,
      );
      if (currentList != null && currentList != _shoppingList) {
        _listUpdatedFromDatabase(currentList);
      }
      updateTaxRate();
    });
  }

  void _listUpdatedFromDatabase(ShoppingList list) {
    _shoppingList = list;
    _emitNewState(list: _shoppingList);
  }

  Future<void> updateList({
    List<Aisle>? aisles,
    int? color,
    List<Item>? items,
    List<Label>? labels,
    String? name,
    String? sortBy,
    bool? sortAscending,
    List<Item>? checkedItems,
  }) async {
    _shoppingList = _shoppingList.copyWith(
      aisles: aisles,
      color: color,
      items: items ?? state.items,
      labels: labels,
      name: name,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
    _emitNewState(list: _shoppingList, checkedItems: checkedItems);
    await _shoppingListRepository.updateShoppingList(_shoppingList);
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

  Future<void> createItem({required String name}) async {
    final newItem = Item(name: name);

    // Quickly emit change while waiting for Firebase to propogate.
    final items = state.items..add(newItem);
    _emitNewState(list: _shoppingList.copyWith(items: items));

    await createItemFromItem(newItem);
  }

  Future<void> createItemFromItem(Item newItem) async {
    final items = List<Item>.from(_shoppingList.items);
    items.removeWhere((item) => item.name == newItem.name);
    items.add(newItem);
    await _shoppingListRepository.updateShoppingList(
      _shoppingList.copyWith(items: items),
    );
  }

  Future<void> updateItem(
      {required Item oldItem, required Item newItem}) async {
    final list = _shoppingList.copyWith()
      ..items.remove(oldItem)
      ..items.add(newItem);
    await updateList(items: list.items);
  }

  Future<void> deleteItem(Item item) async {
    _shoppingList.items.removeWhere((element) => element == item);
    await _shoppingListRepository.updateShoppingList(_shoppingList);
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

  Future<void> setCheckedItemsCompleted() async {
    final completedItems = <Item>[];
    for (var item in state.checkedItems) {
      final completedItem = item.copyWith(isComplete: true);
      completedItems.add(completedItem);
      _shoppingList.items.remove(item);
    }
    state.checkedItems.clear();
    _shoppingList.items.addAll(completedItems);
    await updateList(items: _shoppingList.items);
  }

  Future<void> deleteCompletedItems() async {
    _shoppingList.items.removeWhere((item) => item.isComplete);
    await updateList(items: _shoppingList.items);
  }

  Future<void> createAisle({required String name, int? color}) async {
    final aisle = Aisle(name: name, color: color ?? 0);
    _shoppingList.aisles.add(aisle);
    await updateList(aisles: _shoppingList.aisles);
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

  Future<void> deleteAisle({required Aisle aisle}) async {
    _shoppingList.aisles.remove(aisle);

    // Remove deleted aisle from items.
    final items = _shoppingList.items
        .map((item) => item.copyWith(aisle: verifyAisle(aisle: item.aisle)))
        .toList();

    await updateList(
      aisles: _shoppingList.aisles,
      items: items,
    );
  }

  /// Reorders the aisles in the shopping list.
  Future<void> reorderAisles(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final aisles = List<Aisle>.from(_shoppingList.aisles);
    final aisle = aisles.removeAt(oldIndex);
    aisles.insert(newIndex, aisle);
    await updateList(aisles: aisles);
  }

  String get taxRate => homeCubit.state.taxRate;

  void updateTaxRate() => emit(state.copyWith(taxRate: taxRate));

  Future<void> createLabel({required String name}) async {
    final newLabel = Label(name: name, color: Colors.white.value);
    _shoppingList.labels.add(newLabel);
    await updateList(labels: _shoppingList.labels);
  }

  Future<void> deleteLabel(Label label) async {
    _shoppingList.labels.remove(label);
    await updateList(labels: _shoppingList.labels);
  }

  Future<void> updateAisle({
    required Aisle oldAisle,
    int? color,
    String? name,
  }) async {
    log.v('updateAisle: $oldAisle, $color, $name');
    final updatedAisle = oldAisle.copyWith(
      color: color,
      name: name,
    );
    final index = _shoppingList.aisles.indexOf(oldAisle);
    _shoppingList.aisles
      ..remove(oldAisle)
      ..insert(index, updatedAisle);
    await updateList(aisles: _shoppingList.aisles);
  }

  Future<void> updateLabelColor(
      {required int color, required Label oldLabel}) async {
    final updatedLabel = oldLabel.copyWith(color: color);
    _shoppingList.labels
      ..remove(oldLabel)
      ..add(updatedLabel);
    await updateList(labels: _shoppingList.labels);
  }

  void tiggerShowCreateItemDialog() {
    emit(state.copyWith(showCreateItemDialog: true));
    emit(state.copyWith(showCreateItemDialog: false));
  }

  @override
  Future<void> close() {
    _homeCubitSubscription.cancel();
    return super.close();
  }
}
