import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../shopping_list_repository.dart';

@immutable
class Item extends Equatable {
  final String name;
  final String aisle;
  final String notes;
  final bool isComplete;
  final bool hasTax;
  final String quantity;
  final String price;
  final String total;

  Item({
    required this.name,
    this.aisle = 'None',
    this.notes = '',
    this.isComplete = false,
    this.hasTax = false,
    String quantity = '1',
    this.price = '0.00',
    this.total = '0.00',
  }) : quantity = QuantityValidator(quantity).validate();

  Item copyWith({
    String? name,
    String? aisle,
    String? notes,
    bool? isComplete,
    bool? hasTax,
    String? quantity,
    String? price,
    String? total,
  }) {
    return Item(
      name: name ?? this.name,
      aisle: aisle ?? this.aisle,
      notes: notes ?? this.notes,
      isComplete: isComplete ?? this.isComplete,
      hasTax: hasTax ?? this.hasTax,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
    );
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'aisle': aisle,
      'notes': notes,
      'isComplete': isComplete,
      'hasTax': hasTax,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }

  static Item fromJson(Map<String, Object> json) {
    return Item(
      name: json['name'] as String,
      aisle: json['aisle'] as String,
      notes: json['notes'] as String,
      isComplete: json['isComplete'] as bool,
      hasTax: json['hasTax'] as bool,
      quantity: json['quantity'] as String,
      price: json['price'] as String,
      total: json['total'] as String,
    );
  }

  @override
  List<Object?> get props => [
        name,
        aisle,
        notes,
        isComplete,
        hasTax,
        quantity,
        price,
        total,
      ];

  @override
  String toString() {
    return '''\n
Item {
  name: $name,
  aisle: $aisle,
  notes: $notes,
  isComplete: $isComplete,
  hasTax: $hasTax,
  quantity: $quantity,
  price: $price,
  total: $total,
}\n''';
  }
}
