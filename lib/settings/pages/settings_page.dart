import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../settings.dart';

class SettingsPage extends StatelessWidget {
  static const id = 'settings_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => SettingsCubit(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          builder: (context, state) {
            if (state is SettingsInitial) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SettingsView();
            }
          },
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
                label: 'Tax rate',
                hintText: '${state.taxRate}%',
                keyboardType: TextInputType.number,
                onChanged: (value) => cubit.updateTaxRate(value),
              ),
            ],
          ),
        );
      },
    );
  }
}
