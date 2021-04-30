import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        .shoppingLists()
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

  @override
  Future<void> close() {
    shoppingListSubscription.cancel();
    return super.close();
  }
}
