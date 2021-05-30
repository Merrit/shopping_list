part of 'home_cubit.dart';

/// Holds the central app state for core bits like the
/// currently active list, the shared AppBar & Drawer, etc.
class HomeState {
  /// The id of the active, currently displayed list.
  final String currentListId;

  /// A list of all the lists this user has access to.
  final List<ShoppingList> shoppingLists;

  final String shoppingViewMode;

  HomeState({
    this.currentListId = '',
    this.shoppingLists = const [],
    this.shoppingListCubit,
    required this.shoppingViewMode,
  });

  ShoppingListCubit? shoppingListCubit;

  HomeState copyWith({
    String? currentListId,
    List<ShoppingList>? shoppingLists,
    SharedPreferences? prefs,
    ShoppingListCubit? shoppingListCubit,
    String? shoppingViewMode,
  }) {
    return HomeState(
      currentListId: currentListId ?? this.currentListId,
      shoppingLists: shoppingLists ?? this.shoppingLists,
      shoppingListCubit: shoppingListCubit ?? this.shoppingListCubit,
      shoppingViewMode: shoppingViewMode ?? this.shoppingViewMode,
    );
  }

  @override
  String toString() => '''\n
HomeState: \n
currentListId: $currentListId, 
shoppingLists: $shoppingLists,
shoppingListCubit: $shoppingListCubit,
\n''';
}
