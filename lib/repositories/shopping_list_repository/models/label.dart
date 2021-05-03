import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label.g.dart';

@immutable
@JsonSerializable()
class Label extends Equatable {
  final String name;
  final String color;

  Label({
    required this.name,
    required this.color,
  });

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);

  Label copyWith({
    String? name,
    String? color,
  }) {
    return Label(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object> get props => [name, color];

  @override
  bool get stringify => true;
}
