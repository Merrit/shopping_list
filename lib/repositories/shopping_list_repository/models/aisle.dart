import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'aisle.g.dart';

@immutable
@JsonSerializable()
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

  factory Aisle.fromJson(Map<String, dynamic> json) => _$AisleFromJson(json);

  Map<String, dynamic> toJson() => _$AisleToJson(this);

  // Map<String, String> toJson() {
  //   return {
  //     'name': name,
  //     'color': color,
  //   };
  // }

  // static Aisle fromJson(Map<String, String> json) {
  //   return Aisle(
  //     name: json['name'] as String,
  //     color: json['color'] as String,
  //   );
  // }

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
