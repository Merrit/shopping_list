import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';

void main() {
  test('Removes labels from items that do not exit in shopping list', () {
    final items = [
      Item(name: 'Item1', labels: const ['Label1']),
      Item(name: 'Item2', labels: const ['Label2']),
    ];
    final labels = [
      Label(name: 'Label1', color: Colors.white.value),
    ];
    final validatedItems = ListItemsValidator.validateItems(
      aisles: [],
      items: items,
      labels: labels,
      sortBy: 'Name',
      sortAscending: true,
    );
    expect(validatedItems[1].labels.length, 0);
  });
}
