// import 'package:dartz/dartz.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:shopping_list/domain/core/failures.dart';

// @immutable
// abstract class ValueObject<T> {
//   Either<ValueFailure<T>, T> get value;

//   const ValueObject();

//   @override
//   bool operator ==(Object o) {
//     if (identical(this, o)) return true;

//     return o is ValueObject<T> && o.value == value;
//   }

//   @override
//   int get hashCode => value.hashCode;

//   @override
//   String toString() => 'Value($value)';
// }
