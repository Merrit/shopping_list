import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'item.dart';
import '../entities/entities.dart';

@immutable
class ShoppingList extends Equatable {
  final String name;
  final List<String> aisles;
  final List<Item> items;
  final String id;
  final String owner;
  final List<String> allowedUsers;

  const ShoppingList._internal({
    required this.name,
    required this.aisles,
    required this.items,
    required this.id,
    required this.owner,
    required this.allowedUsers,
  });

  factory ShoppingList({
    required String name,
    List<String> aisles = const [],
    List<Item> items = const [],
    String id = '',
    required String owner,
    List<String> allowedUsers = const [],
  }) {
    return ShoppingList._internal(
      name: name,
      aisles: aisles,
      items: items.toSet().toList(), // Ensure no duplicates.
      id: id,
      owner: owner,
      allowedUsers: allowedUsers,
    );
  }

  ShoppingList copyWith({
    String? name,
    List<String>? aisles,
    List<Item>? items,
    String? id,
    String? owner,
    List<String>? allowedUsers,
  }) {
    return ShoppingList(
      name: name ?? this.name,
      aisles: aisles ?? this.aisles,
      items: items ?? this.items,
      id: id ?? this.id,
      owner: owner ?? this.owner,
      allowedUsers: allowedUsers ?? this.allowedUsers,
    );
  }

  ShoppingListEntity toEntity() {
    return ShoppingListEntity(
      name: name,
      aisles: aisles,
      items: items.map((item) => item.toJson()).toList(),
      id: id,
      owner: owner,
      allowedUsers: allowedUsers,
    );
  }

  static ShoppingList fromEntity(ShoppingListEntity entity) {
    return ShoppingList(
        name: entity.name,
        aisles: entity.aisles,
        items: entity.items.map((json) => Item.fromJson(json)).toList(),
        id: entity.id,
        owner: entity.owner,
        allowedUsers: entity.allowedUsers);
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
