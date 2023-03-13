import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shopping_list/shopping_list.dart';
import '../../shopping_list/cubit/shopping_list_cubit.dart';

class ItemDetailsCubit extends Cubit<Item> {
  ItemDetailsCubit(Item item) : super(item);

  /// Refreshes the item data from the ShoppingListCubit.
  void refresh() {
    final item = ShoppingListCubit.instance.state.items.firstWhere(
      (element) => element.name == state.name,
    );

    emit(item);
  }

  /// Update item value(s). Only affects local state until applied when
  /// leaving the ItemDetailsPage, which is useful because it will mean only 1
  /// call to Firebase for update instead of an update for every change.
  void updateItem(Item item) => emit(item);

  /// Returns the [Item] object with the updated values.
  Item updatedItem() => state;
}
