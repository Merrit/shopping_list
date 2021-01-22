/// Easily prettify input, eg 'bulk barn' => 'Bulk Barn'
/// or 'grapes' => 'Grapes'.
extension Capitalize on String {
  String get capitalizeFirst => '${this[0].toUpperCase()}${this.substring(1)}';
  String get capitalizeAll => this.toUpperCase();
  String get capitalizeFirstOfEach =>
      this.split(' ').map((str) => str.capitalizeFirst).join(' ');
}
