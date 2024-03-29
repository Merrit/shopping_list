import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/settings/cubit/settings_cubit.dart';
import '../../core/core.dart';

class SettingsPage extends StatelessWidget {
  static const id = 'settings_page';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    late SettingsCubit settingsCubit;

    Future<bool> onWillPop(SettingsCubit settingsCubit) async {
      await settingsCubit.updateTaxRate();
      return true;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(settingsCubit),
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
                return const Center(child: CircularProgressIndicator());
              } else {
                return const SettingsView();
              }
            },
          ),
        ),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

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
                label: const Text('Tax rate'),
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
