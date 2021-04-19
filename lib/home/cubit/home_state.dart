part of 'home_cubit.dart';

/// Represents the state of the home page which shows all of
/// the user's existing lists and allows creating new ones.
class HomeState extends Equatable {
  final List<ShoppingList> shoppingLists;

  const HomeState({
    this.shoppingLists = const [],
  });

  HomeState copyWith({List<ShoppingList>? shoppingLists}) {
    return HomeState(
      shoppingLists: shoppingLists ?? this.shoppingLists,
    );
  }

  @override
  List<Object> get props => [shoppingLists];

  @override
  String toString() => 'HomeState: shoppingLists: $shoppingLists';
}
