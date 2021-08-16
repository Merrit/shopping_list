import '../shopping_list_repository.dart';

class AisleValidator {
  const AisleValidator();

  static List<Aisle> validate({
    required List<Aisle> aisles,
    required List<Item> items,
  }) {
    List<Aisle> validatedAisles = deduplicate(aisles);
    validatedAisles = _ItemCounter(aisles: aisles, items: items).validate();
    return validatedAisles;
  }

  // Ensure no duplicates.
  static List<Aisle> deduplicate(List<Aisle> aisles) {
    return aisles.toSet().toList();
  }
}

/// Populate the aisle's count of contained items.
class _ItemCounter {
  final List<Aisle> aisles;
  final List<Item> items;

  const _ItemCounter({
    required this.aisles,
    required this.items,
  });

  List<Aisle> validate() {
    final validatedAisles = <Aisle>[];
    aisles.forEach((aisle) {
      int itemCount = items.where((item) => item.aisle == aisle.name).length;
      validatedAisles.add(aisle.copyWith(itemCount: itemCount));
    });
    return validatedAisles;
  }
}
