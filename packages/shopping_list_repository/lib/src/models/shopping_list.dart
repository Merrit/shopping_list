import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class ShoppingList extends Equatable {
  final String name;
  final List<Aisle> aisles;
  final List<Item> items;
  final String id;
  final String owner;
  final List<String> allowedUsers;
  final List<Label> labels;

  const ShoppingList._internal({
    required this.name,
    required this.aisles,
    required this.items,
    required this.id,
    required this.owner,
    required this.allowedUsers,
    required this.labels,
  });

  factory ShoppingList({
    required String name,
    List<Aisle> aisles = const [],
    List<Item> items = const [],
    String id = '',
    required String owner,
    List<String> allowedUsers = const [],
    List<Label> labels = const [],
  }) {
    return ShoppingList._internal(
      name: name,
      aisles: aisles.toSet().toList(), // Ensure no duplicates.
      items: items.toSet().toList(), // Ensure no duplicates.
      id: id,
      owner: owner,
      allowedUsers: allowedUsers,
      labels: labels.toSet().toList(),
    );
  }

  ShoppingList copyWith({
    String? name,
    List<Aisle>? aisles,
    List<Item>? items,
    String? id,
    String? owner,
    List<String>? allowedUsers,
    List<Label>? labels,
  }) {
    return ShoppingList(
      name: name ?? this.name,
      aisles: aisles ?? this.aisles,
      items: items ?? this.items,
      id: id ?? this.id,
      owner: owner ?? this.owner,
      allowedUsers: allowedUsers ?? this.allowedUsers,
      labels: labels ?? this.labels,
    );
  }

  ShoppingListEntity toEntity() {
    return ShoppingListEntity(
      name: name,
      aisles: aisles.map((aisle) => aisle.toJson()).toList(),
      items: items.map((item) => item.toJson()).toList(),
      id: id,
      owner: owner,
      allowedUsers: allowedUsers,
      labels: labels.map((label) => label.toJson()).toList(),
    );
  }

  static ShoppingList fromEntity(ShoppingListEntity entity) {
    return ShoppingList(
      name: entity.name,
      aisles: entity.aisles.map((json) => Aisle.fromJson(json)).toList(),
      items: entity.items.map((json) => Item.fromJson(json)).toList(),
      id: entity.id,
      owner: entity.owner,
      allowedUsers: entity.allowedUsers,
      labels: entity.labels.map((json) => Label.fromJson(json)).toList(),
    );
  }

  @override
  List<Object> get props => [name, aisles, items, id, owner, allowedUsers];

  @override
  String toString() {
    return '''ShoppingList {
        name: $name,
        aisles: $aisles,
        items: $items,
        id: $id,
        owner: $owner,
        allowedUsers: $allowedUsers,
        }''';
  }
}
