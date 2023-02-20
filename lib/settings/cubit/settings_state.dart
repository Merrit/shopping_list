part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool darkMode;

  const SettingsState({
    required this.darkMode,
  });

  /// Initial state.
  factory SettingsState.initial() {
    return const SettingsState(
      darkMode: false,
    );
  }

  @override
  List<Object?> get props => [darkMode];

  @override
  String toString() => 'SettingsState(darkMode: $darkMode)';

  SettingsState copyWith({
    bool? darkMode,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
