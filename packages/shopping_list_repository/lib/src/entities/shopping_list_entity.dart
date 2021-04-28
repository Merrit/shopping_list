import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ShoppingListEntity extends Equatable {
  final String name;
  final List<Map<String, String>> aisles;
  final List<Map<String, Object>> items;
  final String id;
  final String owner;
  final List<String> allowedUsers;

  const ShoppingListEntity({
    required this.name,
    required this.aisles,
    required this.items,
    required this.id,
    required this.owner,
    required this.allowedUsers,
  });

  Map<String, Object> toJson() {
    return {
      'name': name,
      'aisles': aisles,
      'items': items,
      'id': id,
      'owner': owner,
      'allowedUsers': allowedUsers,
    };
  }

  static ShoppingListEntity fromJson(Map<String, Object> json) {
    return ShoppingListEntity(
      name: json['name'] as String,
      aisles: json['aisles'] as List<Map<String, String>>,
      items: json['items'] as List<Map<String, Object>>,
      id: json['id'] as String,
      owner: json['owner'] as String,
      allowedUsers: json['allowedUsers'] as List<String>,
    );
  }

  static ShoppingListEntity fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();

    return ShoppingListEntity(
      name: data?['name'] as String,
      aisles: _convertAisles(data?['aisles']),
      items: _convertItems(data?['items']),
      id: snapshot.id,
      owner: data?['owner'] as String,
      allowedUsers: List<String>.from(data?['allowedUsers']),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'aisles': aisles,
      'items': items,
      'owner': owner,
      'allowedUsers': allowedUsers,
    };
  }

  @override
  List<Object> get props => [name, aisles, items, id, owner, allowedUsers];

  @override
  String toString() {
    return '''ShoppingListEntity {
        name: $name,
        aisles: $aisles,
        items: $items,
        id: $id,
        owner: $owner,
        allowedUsers: $allowedUsers,
        }''';
  }
}

/// Converting from Firebase Array of Maps to a dart List of Maps.
List<Map<String, Object>> _convertItems(List<dynamic> itemsData) {
  return itemsData.map((item) {
    return Map<String, Object>.from(item);
  }).toList();
}

/// Converting from Firebase Array of Maps to a dart List of Maps.
List<Map<String, String>> _convertAisles(List<dynamic> aislesData) {
  return aislesData.map((aisle) {
    return Map<String, String>.from(aisle);
  }).toList();
}
