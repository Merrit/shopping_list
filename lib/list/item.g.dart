// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    aisle: json['aisle'] as String,
    hasTax: json['hasTax'] as bool,
    isComplete: json['isComplete'] as bool,
    name: json['name'] as String,
    notes: json['notes'] as String,
    price: json['price'] as String,
    quantity: json['quantity'] as String,
    total: json['total'] as String,
    originalJsonData: (json['originalJsonData'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as Map<String, dynamic>),
    ),
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'aisle': instance.aisle,
      'hasTax': instance.hasTax,
      'isComplete': instance.isComplete,
      'name': instance.name,
      'notes': instance.notes,
      'price': instance.price,
      'quantity': instance.quantity,
      'total': instance.total,
      'originalJsonData': instance.originalJsonData,
    };
