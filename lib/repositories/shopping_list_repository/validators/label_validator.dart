import '../repository.dart';

class LabelValidator {
  final List<Item> items;
  final List<Label> labels;

  const LabelValidator({required this.items, required this.labels});

  /// Clean out labels that have been deleted.
  List<Item> validate() {
    final labelNames = labels.map((label) => label.name).toList();
    items.forEach((item) {
      item.labels.removeWhere((label) => !labelNames.contains(label));
    });
    return items;
  }
}
