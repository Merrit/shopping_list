import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'aisle.g.dart';

@immutable
@JsonSerializable()
class Aisle extends Equatable {
  final String name;
  final int color;

  Aisle({
    required this.name,
    this.color = 0,
  });

  Aisle copyWith({
    String? name,
    int? color,
  }) {
    return Aisle(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  factory Aisle.fromJson(Map<String, dynamic> json) => _$AisleFromJson(json);

  Map<String, dynamic> toJson() => _$AisleToJson(this);

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
