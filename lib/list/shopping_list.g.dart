// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return ShoppingList(
    (json['aisles'] as List<dynamic>).map((e) => e as String).toList(),
    (json['items'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Item.fromJson(e as Map<String, dynamic>)),
    ),
    json['name'] as String,
  );
}

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) =>
    <String, dynamic>{
      'aisles': instance.aisles,
      'items': instance.items.map((k, e) => MapEntry(k, e.toJson())),
      'name': instance.name,
    };
