part of 'home_cubit.dart';

/// Holds the central app state for core bits like the
/// currently active list, the shared AppBar & Drawer, etc.
class HomeState {
  /// The id of the active, currently displayed list.
  final String currentListId;

  /// A list of all the lists this user has access to.
  final List<ShoppingList> shoppingLists;

  /// If provided the main page Scaffold will display the given message in a
  /// snackbar.
  final String snackBarMsg;

  final bool taxRateIsSet;
  final String taxRate;

  HomeState({
    this.snackBarMsg = '',
    required this.currentListId,
    required this.shoppingLists,
    required this.taxRateIsSet,
    required this.shoppingListCubit,
    required this.taxRate,
  });

  HomeState.initial({
    this.snackBarMsg = '',
    this.shoppingLists = const [],
    this.currentListId = '',
    this.taxRateIsSet = false,
    String? taxRate,
  }) : taxRate = taxRate ?? '0.0';

  ShoppingListCubit? shoppingListCubit;

  HomeState copyWith({
    String? currentListId,
    List<ShoppingList>? shoppingLists,
    bool? taxRateIsSet,
    String? snackBarMsg,
    ShoppingListCubit? shoppingListCubit,
    String? taxRate,
  }) {
    return HomeState(
      currentListId: currentListId ?? this.currentListId,
      snackBarMsg: snackBarMsg ?? this.snackBarMsg,
      shoppingLists: shoppingLists ?? this.shoppingLists,
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
snackBarMsg: $snackBarMsg,
\n''';
}
