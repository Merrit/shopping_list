import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/shopping_list_repository/models/item.dart';

class ItemDetailsCubit extends Cubit<Item> {
  ItemDetailsCubit(Item item) : super(item);

  /// Update item value(s). Only affects local state until applied when
  /// leaving the ItemDetailsPage, which is useful because it will mean only 1
  /// call to Firebase for update instead of an update for every change.
  void updateItem(Item item) => emit(item);

  /// Returns the [Item] object with the updated values.
  Item updatedItem() => state;
}
