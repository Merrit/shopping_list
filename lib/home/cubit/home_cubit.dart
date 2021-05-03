import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/core/helpers/money_handler.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ShoppingListRepository shoppingListRepository;
  late StreamSubscription shoppingListSubscription;
  final User user;

  HomeCubit({
    required this.shoppingListRepository,
    required this.user,
  }) : super(HomeState()) {
    _initPrefs();
    shoppingListSubscription = shoppingListRepository
        .shoppingListsStream()
        .listen((shoppingLists) => _listsChanged(shoppingLists));
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
