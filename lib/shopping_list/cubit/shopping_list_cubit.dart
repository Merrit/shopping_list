import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  late StreamSubscription _homeCubitSubscription;
  late ShoppingList _shoppingList;
  final ShoppingListRepository _shoppingListRepository;

  ShoppingListCubit({
    required HomeCubit homeCubit,
  })  : _shoppingList = ShoppingList(name: '', owner: homeCubit.user.id),
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

  void _listenToHomeCubit(HomeCubit homeCubit) {
    _homeCubitSubscription = homeCubit.stream.listen((HomeState event) {
      final currentList = event.shoppingLists.firstWhereOrNull(
        (list) => list.id == event.currentListId,
      );
      if (currentList != null && currentList != _shoppingList) {
        _listChanged(currentList);
      }
    });
  }

  void _listChanged(ShoppingList list) {
    _shoppingList = list;
    emit(state.copyWith(
      name: list.name,
      items: list.items,
    ));
  }

  void updateListName(String value) {
    _shoppingListRepository.updateShoppingList(
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

  @override
  Future<void> close() {
    _homeCubitSubscription.cancel();
    return super.close();
  }
}
