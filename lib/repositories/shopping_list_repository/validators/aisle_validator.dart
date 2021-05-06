import '../repository.dart';

class AisleValidator {
  const AisleValidator();

  static List<Aisle> validate(List<Aisle> aisles) {
    // Ensure no duplicates.
    // TODO: Why are we getting duplicates?
    final validated = <Aisle>[];
    final names = <String>[];
    aisles.forEach((aisle) {
      if (!names.contains(aisle.name)) {
        names.add(aisle.name);
        validated.add(aisle);
      }
    });
    return validated;
  }
}
