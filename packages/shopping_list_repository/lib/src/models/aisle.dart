import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Aisle extends Equatable {
  final String name;
  final String color;

  Aisle({
    required this.name,
    this.color = '',
  });

  Aisle copyWith({
    String? name,
    String? color,
  }) {
    return Aisle(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'color': color,
    };
  }

  static Aisle fromJson(Map<String, String> json) {
    return Aisle(
      name: json['name'] as String,
      color: json['color'] as String,
    );
  }

  @override
  List<Object?> get props => [name, color];

  @override
  String toString() {
    return '''Aisle {
        name: $name,
        color: $color,
        }''';
  }
}
