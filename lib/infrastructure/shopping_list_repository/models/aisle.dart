import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'aisle.g.dart';

@immutable
@JsonSerializable()
class Aisle extends Equatable {
  final String name;
  final int color;

  @JsonKey(defaultValue: 0)
  final int itemCount;

  const Aisle({
    required this.name,
    this.color = 0,
    this.itemCount = 0,
  });

  Aisle copyWith({
    String? name,
    int? color,
    int? itemCount,
  }) {
    return Aisle(
      name: name ?? this.name,
      color: color ?? this.color,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  factory Aisle.fromJson(Map<String, dynamic> json) => _$AisleFromJson(json);

  Map<String, dynamic> toJson() => _$AisleToJson(this);

  @override
  List<Object> get props => [name];

  @override
  bool get stringify => true;
}

extension AisleExtension on List<Aisle> {
  /// Returns the verified list of aisles.
  List<Aisle> verify() {
    List<Aisle> aisles;
    aisles = _removeDuplicates();
    return aisles;
  }

  /// Remove duplicates if they exist.
  List<Aisle> _removeDuplicates() {
    final aisles = <Aisle>[];
    for (final aisle in this) {
      if (!aisles.any((element) => element.name == aisle.name)) {
        aisles.add(aisle);
      }
    }
    return aisles;
  }
}
