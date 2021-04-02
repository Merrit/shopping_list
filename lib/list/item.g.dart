// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    aisle: json['aisle'] as String,
    isComplete: json['isComplete'] as bool,
    name: json['name'] as String,
    notes: json['notes'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: (json['quantity'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'aisle': instance.aisle,
      'isComplete': instance.isComplete,
      'name': instance.name,
      'notes': instance.notes,
      'price': instance.price,
      'quantity': instance.quantity,
      'total': instance.total,
    };
