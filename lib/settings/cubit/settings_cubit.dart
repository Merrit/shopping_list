import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SharedPreferences? prefs;
  SettingsCubit() : super(SettingsInitial()) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final taxRate = prefs!.getString('taxRate') ?? '0.0';
    emit(SettingsLoaded(taxRate: taxRate));
  }

  Future<void> updateTaxRate(String taxRate) async {
    final isNumber = NumberValidator(taxRate).isValidNumber();
    if (isNumber) {
      emit(state.copyWith(taxRate: taxRate));
      await prefs!.setString('taxRate', taxRate);
    } else {
      // emit error or do update
    }
  }
}
