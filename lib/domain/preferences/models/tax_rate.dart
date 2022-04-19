import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';

@immutable
class TaxRate extends Equatable {
  final String taxRate;

  TaxRate._internal({required String taxRate})
      : taxRate = (NumberValidator(taxRate).isValidNumber()) ? taxRate : '0.0';

  factory TaxRate({String? taxRate}) {
    return TaxRate._internal(taxRate: taxRate ?? '0.0');
  }

  TaxRate copyWith({String? taxRate}) {
    return TaxRate._internal(taxRate: taxRate ?? this.taxRate);
  }

  @override
  List<Object> get props => [taxRate];

  @override
  bool get stringify => true;
}
