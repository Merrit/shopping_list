import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsCubit(Item item)
      : super(ItemDetailsState(
          item: item,
          name: item.name,
          quantity: item.quantity,
          aisle: item.aisle,
        ));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateQuantity(String quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void updateAisle(String aisle) {
    emit(state.copyWith(aisle: aisle));
  }

  Item updatedItem() {
    return state._item.copyWith(
      aisle: state.aisle,
      name: state.name,
      quantity: state.quantity,
    );
  }
}
