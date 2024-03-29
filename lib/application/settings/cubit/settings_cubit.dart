import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../home/cubit/home_cubit.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final HomeCubit _homeCubit;
  SharedPreferences? prefs;
  SettingsCubit({required HomeCubit homeCubit})
      : _homeCubit = homeCubit,
        super(SettingsInitial()) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final taxRate = prefs!.getString('taxRate') ?? '0.0';
    emit(SettingsLoaded(taxRate: taxRate));
  }

  String _taxRate = '';

  void recordTaxRateState(String taxRate) => _taxRate = taxRate;

  Future<void> updateTaxRate() async {
    final isNumber = NumberValidator(_taxRate).isValidNumber();
    if (isNumber) {
      // emit loading
      await prefs!.setString('taxRate', _taxRate);
      await _homeCubit.updateListItemTotals(_taxRate);
      emit(state.copyWith(taxRate: _taxRate));
    } else {
      // emit error or do update
    }
  }
}
