part of 'home_cubit.dart';

/// Represents the state of the home page which shows all of
/// the user's existing lists and allows creating new ones.
class HomeState {
  final String currentListId;
  final List<ShoppingList> shoppingLists;

  const HomeState({
    this.currentListId = '',
    this.shoppingLists = const [],
  });

  HomeState copyWith(
      {String? currentListId, List<ShoppingList>? shoppingLists}) {
    return HomeState(
      currentListId: currentListId ?? this.currentListId,
      shoppingLists: shoppingLists ?? this.shoppingLists,
    );
  }

  // !!
  // New state is not emitted with Equatable.
  // It considers changed list to be equatable.
  //
  // @override
  // List<Object> get props => [currentListId, shoppingLists];

  @override
  String toString() =>
      'HomeState: currentListId: $currentListId, shoppingLists: $shoppingLists';
}
