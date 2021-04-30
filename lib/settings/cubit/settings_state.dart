part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  final String taxRate;

  const SettingsState() : taxRate = '';

  @override
  List<Object> get props => [taxRate];

  SettingsLoaded copyWith({
    String? taxRate,
  }) {
    return SettingsLoaded(
      taxRate: taxRate ?? this.taxRate,
    );
  }
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  @override
  final String taxRate;

  const SettingsLoaded({required this.taxRate});

  @override
  SettingsLoaded copyWith({
    String? taxRate,
  }) {
    return SettingsLoaded(
      taxRate: taxRate ?? this.taxRate,
    );
  }

  @override
  List<Object> get props => [taxRate];

  @override
  String toString() => 'SettingsLoaded(taxRate: $taxRate)';
}
