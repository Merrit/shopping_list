part of 'home_cubit.dart';

/// Represents the state of the home page which shows all of
/// the user's existing lists and allows creating new ones.
class HomeState {
  final String currentListId;
  final List<ShoppingList> shoppingLists;

  HomeState({
    this.currentListId = '',
    this.shoppingLists = const [],
    this.prefs,
    this.shoppingListCubit,
  });

  SharedPreferences? prefs;
  ShoppingListCubit? shoppingListCubit;

  HomeState copyWith({
    String? currentListId,
    List<ShoppingList>? shoppingLists,
    SharedPreferences? prefs,
    ShoppingListCubit? shoppingListCubit,
  }) {
    return HomeState(
      currentListId: currentListId ?? this.currentListId,
      shoppingLists: shoppingLists ?? this.shoppingLists,
      prefs: prefs ?? this.prefs,
      shoppingListCubit: shoppingListCubit ?? this.shoppingListCubit,
    );
  }

  @override
  String toString() => 'HomeState: currentListId: $currentListId, '
      'shoppingLists: $shoppingLists '
      'prefs: $prefs'
      'shoppingListCubit: $shoppingListCubit';
}
