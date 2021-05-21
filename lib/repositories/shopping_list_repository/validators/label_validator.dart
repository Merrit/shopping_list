import '../repository.dart';

class LabelValidator {
  final List<Item> items;
  final List<Label> labels;

  const LabelValidator({required this.items, required this.labels});

  /// Clean out labels that have been deleted.
  List<Item> validate() {
    final labelNames = labels.map((label) => label.name).toList();
    for (var item in items) {
      final labels = List<String>.from(item.labels);
      labels.removeWhere((label) => !labelNames.contains(label));
      item = item.copyWith(labels: labels);
    }
    return items;
  }
}
