import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  final String _listId;

  ShoppingListCubit({
    required String listId,
  })  : _listId = listId,
        super(ShoppingListInitial());
}
