import 'package:bloc/bloc.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsCubit(Item item)
      : super(ItemDetailsState(
          item: item,
          aisle: item.aisle,
          hasTax: item.hasTax,
          labels: item.labels,
          name: item.name,
          notes: item.notes,
          price: item.price,
          quantity: item.quantity,
          total: item.total,
        ));

  /// Update item value(s). Only affects local state until applied when
  /// leaving the ItemDetailsPage.
  void updateItem({
    String? aisle,
    bool? hasTax,
    List<String>? labels,
    String? name,
    String? notes,
    String? price,
    String? quantity,
    String? total,
  }) {
    emit(
      state.copyWith(
        aisle: aisle,
        hasTax: hasTax,
        labels: labels,
        name: name,
        notes: notes,
        price: price,
        quantity: quantity,
        total: total,
      ),
    );
  }

  /// Toggle whether a label is applied to this item or not.
  void toggleLabel(String label) {
    final labels = List<String>.from(state.labels);
    if (labels.contains(label)) {
      labels.remove(label);
    } else {
      labels.add(label);
    }
    updateItem(labels: labels);
  }

  /// Returns the `Item` object with the updated values.
  Item updatedItem() {
    return state._item.copyWith(
      aisle: state.aisle,
      name: state.name,
      quantity: state.quantity,
      price: state.price,
      total: state.total,
      hasTax: state.hasTax,
      notes: state.notes,
      labels: state.labels,
    );
  }
}
