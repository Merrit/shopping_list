part of 'home_cubit.dart';

/// Holds the central app state for core bits like the
/// currently active list, the shared AppBar & Drawer, etc.
class HomeState {
  /// The id of the active, currently displayed list.
  final String currentListId;

  /// A list of all the lists this user has access to.
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
  String toString() => '''\n
HomeState: \n
currentListId: $currentListId, 
shoppingLists: $shoppingLists,
prefs: $prefs,
shoppingListCubit: $shoppingListCubit,
\n''';
}
