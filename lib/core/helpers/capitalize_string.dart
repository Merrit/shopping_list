// ignore_for_file: unnecessary_this

/// Easily prettify input, eg 'bulk barn' => 'Bulk Barn'
/// or 'grapes' => 'Grapes'.
extension Capitalize on String {
  /// Capitalize the first letter, eg: `bulk barn` => `Bulk barn`.
  String get capitalizeFirst {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  /// Capitalize all characters, eg: `bulk barn` => `BULK BARN`.
  String get capitalizeAll => this.toUpperCase();

  /// Capitalize first character per word, eg `bulk barn` => `Bulk Barn`.
  String get capitalizeFirstOfEach =>
      this.split(' ').map((str) => str.capitalizeFirst).join(' ');
}
