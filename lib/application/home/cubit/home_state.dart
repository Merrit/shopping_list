part of 'home_cubit.dart';

/// Holds the central app state for core bits like the
/// currently active list, the shared AppBar & Drawer, etc.
class HomeState {
  /// The id of the active, currently displayed list.
  final String currentListId;

  /// A list of all the lists this user has access to.
  final List<ShoppingList> shoppingLists;

  final String shoppingViewMode;
  final bool taxRateIsSet;
  final String taxRate;

  HomeState({
    required this.currentListId,
    required this.shoppingLists,
    required this.shoppingViewMode,
    required this.taxRateIsSet,
    required this.shoppingListCubit,
    required this.taxRate,
  });

  HomeState.initial({
    this.shoppingLists = const [],
    this.currentListId = '',
    required this.shoppingViewMode,
    this.taxRateIsSet = false,
    String? taxRate,
  }) : taxRate = taxRate ?? '0.0';

  ShoppingListCubit? shoppingListCubit;

  HomeState copyWith({
    String? currentListId,
    List<ShoppingList>? shoppingLists,
    String? shoppingViewMode,
    bool? taxRateIsSet,
    ShoppingListCubit? shoppingListCubit,
    String? taxRate,
  }) {
    return HomeState(
      currentListId: currentListId ?? this.currentListId,
      shoppingLists: shoppingLists ?? this.shoppingLists,
      shoppingViewMode: shoppingViewMode ?? this.shoppingViewMode,
      taxRateIsSet: taxRateIsSet ?? this.taxRateIsSet,
      shoppingListCubit: shoppingListCubit ?? this.shoppingListCubit,
      taxRate: taxRate ?? this.taxRate,
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
