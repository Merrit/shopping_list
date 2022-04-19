import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../domain/preferences/preferences.dart';
import '../../../infrastructure/authentication_repository/authentication_repository.dart';
import '../../../infrastructure/preferences/preferences_repository.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../shopping_list/cubit/shopping_list_cubit.dart';

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
          HomeState.initial(
            shoppingViewMode: _getViewMode(_preferencesRepository),
            taxRateIsSet: _taxRateIsSet(_preferencesRepository),
            taxRate: _getTaxRate(_preferencesRepository),
          ),
        ) {
    _init();
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

  static bool _taxRateIsSet(PreferencesRepository _preferencesRepository) {
    final taxRateFromPrefs = _preferencesRepository.getKey('taxRate');
    return (taxRateFromPrefs == null) ? false : true;
  }

  static String? _getTaxRate(PreferencesRepository _preferencesRepository) {
    return _preferencesRepository.getKey('taxRate') as String?;
  }

  void _init() async {
    await _getSavedListId();
  }

  Future<void> _getSavedListId() async {
    final shoppingLists = await shoppingListRepository.shoppingLists();
    final listIds = <String>[];
    for (var list in shoppingLists) {
      listIds.add(list.id);
    }
    var savedId = _preferencesRepository.getKey('currentList') as String?;
    if (savedId == null) return;
    final bool savedIdExists = listIds.contains(savedId);
    if (savedIdExists) {
      emit(state.copyWith(currentListId: savedId));
    }
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
        aisles: const [Aisle(name: 'None')],
        owner: user.id,
      ),
    );
  }

  void setCurrentList(String listId) {
    _preferencesRepository.setString(key: 'currentList', value: listId);
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
    if (!newList.aisles.map((e) => e.name).contains(item.aisle)) {
      newList.aisles.add(
        oldList.aisles.firstWhere((element) => element.name == item.aisle),
      );
    }
    for (var label in oldList.labels) {
      if (!newList.labels.contains(label)) {
        newList.labels.add(label);
      }
    }
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

  void updateTaxRate(String newRate) {
    final validatedRate = TaxRate(taxRate: newRate);
    emit(
      state.copyWith(
        taxRate: validatedRate.taxRate,
        taxRateIsSet: (validatedRate.taxRate == '0.0') ? false : true,
      ),
    );
    _preferencesRepository.setString(
      key: 'taxRate',
      value: validatedRate.taxRate,
    );
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
    for (var list in lists) {
      await _updateListItemTotals(list: list, taxRate: taxRate);
    }
  }

  Future<void> _updateListItemTotals({
    required ShoppingList list,
    required String taxRate,
  }) async {
    final updatedItems = <Item>[];
    for (var item in list.items) {
      final updatedTotal = MoneyHandler().totalPrice(
        price: item.price,
        quantity: item.quantity,
        taxRate: (item.hasTax) ? taxRate : null,
      );
      final updatedItem = item.copyWith(total: updatedTotal);
      updatedItems.add(updatedItem);
    }
    await shoppingListRepository.updateShoppingList(
      list.copyWith(items: updatedItems),
    );
  }
}
