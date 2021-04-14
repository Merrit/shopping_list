// // GENERATED CODE - DO NOT MODIFY BY HAND
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

// part of 'failures.dart';

// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************

// T _$identity<T>(T value) => value;

// final _privateConstructorUsedError = UnsupportedError(
//     'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

// /// @nodoc
// class _$ValueFailureTearOff {
//   const _$ValueFailureTearOff();

//   InvalidEmail<T> invalidEmail<T>({required String failedValue}) {
//     return InvalidEmail<T>(
//       failedValue: failedValue,
//     );
//   }

//   BadPassword<T> badPassword<T>({required String failedValue}) {
//     return BadPassword<T>(
//       failedValue: failedValue,
//     );
//   }
// }

// /// @nodoc
// const $ValueFailure = _$ValueFailureTearOff();

// /// @nodoc
// mixin _$ValueFailure<T> {
//   String get failedValue => throw _privateConstructorUsedError;

//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String failedValue) invalidEmail,
//     required TResult Function(String failedValue) badPassword,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String failedValue)? invalidEmail,
//     TResult Function(String failedValue)? badPassword,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(InvalidEmail<T> value) invalidEmail,
//     required TResult Function(BadPassword<T> value) badPassword,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(InvalidEmail<T> value)? invalidEmail,
//     TResult Function(BadPassword<T> value)? badPassword,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;

//   @JsonKey(ignore: true)
//   $ValueFailureCopyWith<T, ValueFailure<T>> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class $ValueFailureCopyWith<T, $Res> {
//   factory $ValueFailureCopyWith(
//           ValueFailure<T> value, $Res Function(ValueFailure<T>) then) =
//       _$ValueFailureCopyWithImpl<T, $Res>;
//   $Res call({String failedValue});
// }

// /// @nodoc
// class _$ValueFailureCopyWithImpl<T, $Res>
//     implements $ValueFailureCopyWith<T, $Res> {
//   _$ValueFailureCopyWithImpl(this._value, this._then);

//   final ValueFailure<T> _value;
//   // ignore: unused_field
//   final $Res Function(ValueFailure<T>) _then;

//   @override
//   $Res call({
//     Object? failedValue = freezed,
//   }) {
//     return _then(_value.copyWith(
//       failedValue: failedValue == freezed
//           ? _value.failedValue
//           : failedValue // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc
// abstract class $InvalidEmailCopyWith<T, $Res>
//     implements $ValueFailureCopyWith<T, $Res> {
//   factory $InvalidEmailCopyWith(
//           InvalidEmail<T> value, $Res Function(InvalidEmail<T>) then) =
//       _$InvalidEmailCopyWithImpl<T, $Res>;
//   @override
//   $Res call({String failedValue});
// }

// /// @nodoc
// class _$InvalidEmailCopyWithImpl<T, $Res>
//     extends _$ValueFailureCopyWithImpl<T, $Res>
//     implements $InvalidEmailCopyWith<T, $Res> {
//   _$InvalidEmailCopyWithImpl(
//       InvalidEmail<T> _value, $Res Function(InvalidEmail<T>) _then)
//       : super(_value, (v) => _then(v as InvalidEmail<T>));

//   @override
//   InvalidEmail<T> get _value => super._value as InvalidEmail<T>;

//   @override
//   $Res call({
//     Object? failedValue = freezed,
//   }) {
//     return _then(InvalidEmail<T>(
//       failedValue: failedValue == freezed
//           ? _value.failedValue
//           : failedValue // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc
// class _$InvalidEmail<T> implements InvalidEmail<T> {
//   const _$InvalidEmail({required this.failedValue});

//   @override
//   final String failedValue;

//   @override
//   String toString() {
//     return 'ValueFailure<$T>.invalidEmail(failedValue: $failedValue)';
//   }

//   @override
//   bool operator ==(dynamic other) {
//     return identical(this, other) ||
//         (other is InvalidEmail<T> &&
//             (identical(other.failedValue, failedValue) ||
//                 const DeepCollectionEquality()
//                     .equals(other.failedValue, failedValue)));
//   }

//   @override
//   int get hashCode =>
//       runtimeType.hashCode ^ const DeepCollectionEquality().hash(failedValue);

//   @JsonKey(ignore: true)
//   @override
//   $InvalidEmailCopyWith<T, InvalidEmail<T>> get copyWith =>
//       _$InvalidEmailCopyWithImpl<T, InvalidEmail<T>>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String failedValue) invalidEmail,
//     required TResult Function(String failedValue) badPassword,
//   }) {
//     return invalidEmail(failedValue);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String failedValue)? invalidEmail,
//     TResult Function(String failedValue)? badPassword,
//     required TResult orElse(),
//   }) {
//     if (invalidEmail != null) {
//       return invalidEmail(failedValue);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(InvalidEmail<T> value) invalidEmail,
//     required TResult Function(BadPassword<T> value) badPassword,
//   }) {
//     return invalidEmail(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(InvalidEmail<T> value)? invalidEmail,
//     TResult Function(BadPassword<T> value)? badPassword,
//     required TResult orElse(),
//   }) {
//     if (invalidEmail != null) {
//       return invalidEmail(this);
//     }
//     return orElse();
//   }
// }

// abstract class InvalidEmail<T> implements ValueFailure<T> {
//   const factory InvalidEmail({required String failedValue}) = _$InvalidEmail<T>;

//   @override
//   String get failedValue => throw _privateConstructorUsedError;
//   @override
//   @JsonKey(ignore: true)
//   $InvalidEmailCopyWith<T, InvalidEmail<T>> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class $BadPasswordCopyWith<T, $Res>
//     implements $ValueFailureCopyWith<T, $Res> {
//   factory $BadPasswordCopyWith(
//           BadPassword<T> value, $Res Function(BadPassword<T>) then) =
//       _$BadPasswordCopyWithImpl<T, $Res>;
//   @override
//   $Res call({String failedValue});
// }

// /// @nodoc
// class _$BadPasswordCopyWithImpl<T, $Res>
//     extends _$ValueFailureCopyWithImpl<T, $Res>
//     implements $BadPasswordCopyWith<T, $Res> {
//   _$BadPasswordCopyWithImpl(
//       BadPassword<T> _value, $Res Function(BadPassword<T>) _then)
//       : super(_value, (v) => _then(v as BadPassword<T>));

//   @override
//   BadPassword<T> get _value => super._value as BadPassword<T>;

//   @override
//   $Res call({
//     Object? failedValue = freezed,
//   }) {
//     return _then(BadPassword<T>(
//       failedValue: failedValue == freezed
//           ? _value.failedValue
//           : failedValue // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc
// class _$BadPassword<T> implements BadPassword<T> {
//   const _$BadPassword({required this.failedValue});

//   @override
//   final String failedValue;

//   @override
//   String toString() {
//     return 'ValueFailure<$T>.badPassword(failedValue: $failedValue)';
//   }

//   @override
//   bool operator ==(dynamic other) {
//     return identical(this, other) ||
//         (other is BadPassword<T> &&
//             (identical(other.failedValue, failedValue) ||
//                 const DeepCollectionEquality()
//                     .equals(other.failedValue, failedValue)));
//   }

//   @override
//   int get hashCode =>
//       runtimeType.hashCode ^ const DeepCollectionEquality().hash(failedValue);

//   @JsonKey(ignore: true)
//   @override
//   $BadPasswordCopyWith<T, BadPassword<T>> get copyWith =>
//       _$BadPasswordCopyWithImpl<T, BadPassword<T>>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String failedValue) invalidEmail,
//     required TResult Function(String failedValue) badPassword,
//   }) {
//     return badPassword(failedValue);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String failedValue)? invalidEmail,
//     TResult Function(String failedValue)? badPassword,
//     required TResult orElse(),
//   }) {
//     if (badPassword != null) {
//       return badPassword(failedValue);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(InvalidEmail<T> value) invalidEmail,
//     required TResult Function(BadPassword<T> value) badPassword,
//   }) {
//     return badPassword(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(InvalidEmail<T> value)? invalidEmail,
//     TResult Function(BadPassword<T> value)? badPassword,
//     required TResult orElse(),
//   }) {
//     if (badPassword != null) {
//       return badPassword(this);
//     }
//     return orElse();
//   }
// }

// abstract class BadPassword<T> implements ValueFailure<T> {
//   const factory BadPassword({required String failedValue}) = _$BadPassword<T>;

//   @override
//   String get failedValue => throw _privateConstructorUsedError;
//   @override
//   @JsonKey(ignore: true)
//   $BadPasswordCopyWith<T, BadPassword<T>> get copyWith =>
//       throw _privateConstructorUsedError;
// }
