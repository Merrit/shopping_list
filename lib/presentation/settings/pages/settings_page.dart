import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/home/cubit/home_cubit.dart';
import 'package:shopping_list/application/settings/cubit/settings_cubit.dart';
import 'package:shopping_list/presentation/core/core.dart';

class SettingsPage extends StatelessWidget {
  static const id = 'settings_page';

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    late SettingsCubit settingsCubit;

    Future<bool> _onWillPop(SettingsCubit settingsCubit) async {
      await settingsCubit.updateTaxRate();
      return true;
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(settingsCubit),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocProvider(
          create: (context) => SettingsCubit(homeCubit: homeCubit),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              settingsCubit = context.read<SettingsCubit>();
              if (state is SettingsInitial) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SettingsView();
              }
            },
          ),
        ),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 100,
          ),
          child: Column(
            children: [
              SettingsTile(
                label: Text('Tax rate'),
                hintText: '${state.taxRate}%',
                keyboardType: TextInputType.number,
                onChanged: (value) => cubit.recordTaxRateState(value),
              ),
            ],
          ),
        );
      },
    );
  }
}
