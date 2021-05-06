import 'package:bloc/bloc.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsCubit(Item item)
      : super(ItemDetailsState(
          item: item,
          name: item.name,
          quantity: item.quantity,
          aisle: item.aisle,
          price: item.price,
          total: item.total,
          hasTax: item.hasTax,
          notes: item.notes,
          labels: item.labels,
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

  void updatePrice(String price) {
    final asDouble = double.tryParse(price);
    emit(state.copyWith(price: asDouble.toString()));
  }

  void updateTotal() {
    if (state.hasTax) {
      // final total = state.price
      emit(state.copyWith());
    }
  }

  void updateHasTax(bool hasTax) {
    emit(state.copyWith(hasTax: hasTax));
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void toggleLabel(String label) {
    final labels = state.labels;
    if (labels.contains(label)) {
      labels.remove(label);
    } else {
      labels.add(label);
    }
    emit(state.copyWith(labels: labels));
  }

  Item updatedItem() {
    return state._item.copyWith(
      aisle: state.aisle,
      name: state.name,
      quantity: state.quantity,
      price: state.price,
      total: state.total,
      hasTax: state.hasTax,
      notes: state.notes,
    );
  }
}
