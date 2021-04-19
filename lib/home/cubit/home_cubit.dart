import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ShoppingListRepository _shoppingListRepository;
  late StreamSubscription _shoppingListSubscription;
  final User user;

  HomeCubit({
    required ShoppingListRepository shoppingListRepository,
    required this.user,
  })  : _shoppingListRepository = shoppingListRepository,
        super(HomeState()) {
    _shoppingListSubscription = _shoppingListRepository
        .shoppingLists()
        .listen((shoppingLists) => _listsChanged(shoppingLists));
  }

  void _listsChanged(List<ShoppingList> shoppingLists) {
    emit(state.copyWith(
      shoppingLists: shoppingLists,
    ));
  }

  void createList({required String name}) {
    _shoppingListRepository.createNewShoppingList(
      ShoppingList(
        name: name,
        owner: user.id,
      ),
    );
  }

  @override
  Future<void> close() {
    _shoppingListSubscription.cancel();
    return super.close();
  }
}
