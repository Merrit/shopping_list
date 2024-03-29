import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../shopping_list.dart';

part 'shopping_list.g.dart';

const _defaultListColor = 4294967295; // White

@immutable
@JsonSerializable(explicitToJson: true)
class ShoppingList extends Equatable {
  final List<Aisle> aisles;
  final List<String> allowedUsers;
  final String id;

  /// If not provided the index defaults to `-1` to indicated this list has
  /// not yet been properly assigned an order and must be dealt with.
  final int index;

  final List<Item> items;
  final List<Label> labels;
  final String name;
  final String owner;

  @JsonKey(defaultValue: _defaultListColor)
  final int color;

  @JsonKey(defaultValue: 'Name')
  final String sortBy;

  @JsonKey(defaultValue: true)
  final bool sortAscending;

  const ShoppingList._internal({
    required this.name,
    required this.aisles,
    required this.color,
    required this.index,
    required this.items,
    required this.id,
    required this.owner,
    required this.allowedUsers,
    required this.labels,
    required this.sortBy,
    required this.sortAscending,
  });

  factory ShoppingList({
    required String name,
    List<Aisle> aisles = const [],
    int index = -1,
    List<Item> items = const [],
    int color = _defaultListColor,
    String id = '',
    required String owner,
    List<String> allowedUsers = const [],
    List<Label> labels = const [],
    String sortBy = 'Name',
    bool sortAscending = true,
  }) {
    final validatedItems = ListItemsValidator.validateItems(
      aisles: aisles,
      items: items,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
    final validatedAisles = AisleValidator.validate(
      aisles: aisles,
      items: validatedItems,
    );
    return ShoppingList._internal(
      name: name,
      aisles: validatedAisles,
      items: validatedItems,
      color: color,
      id: id,
      index: index,
      owner: owner,
      allowedUsers: allowedUsers,
      labels: labels.toSet().toList(), // Ensure no duplicates.
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
  }

  ShoppingList copyWith({
    String? name,
    List<Aisle>? aisles,
    int? color,
    List<Item>? items,
    String? id,
    int? index,
    String? owner,
    List<String>? allowedUsers,
    List<Label>? labels,
    String? sortBy,
    bool? sortAscending,
  }) {
    return ShoppingList(
      name: name ?? this.name,
      aisles: aisles ?? this.aisles,
      color: color ?? this.color,
      items: items ?? this.items,
      id: id ?? this.id,
      index: index ?? this.index,
      owner: owner ?? this.owner,
      allowedUsers: allowedUsers ?? this.allowedUsers,
      labels: labels ?? this.labels,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);

  @override
  List<Object> get props => [
        name,
        aisles,
        items,
        id,
        index,
        owner,
        allowedUsers,
        color,
        labels,
        sortBy,
        sortAscending,
      ];

  @override
  String toString() {
    return '''\n
ShoppingList {
  name: $name,
  aisles: $aisles,
  items: $items,
  id: $id,
  index: $index,
  owner: $owner,
  allowedUsers: $allowedUsers,
  color: $color,
  labels: $labels,
  sortBy: $sortBy,
  sortAscending: $sortAscending,
}
\n''';
  }
}
