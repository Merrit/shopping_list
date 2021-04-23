import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
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
    shoppingListSubscription = shoppingListRepository
        .shoppingLists()
        .listen((shoppingLists) => _listsChanged(shoppingLists));
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
