import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/preferences/preferences.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  SharedPreferences prefs;
  String taxRate;

  final TextEditingController taxRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prefs = Preferences.prefs;
    taxRate = prefs.get('taxRate') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preferences')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SettingsList(
          darkBackgroundColor: Colors.grey[850],
          sections: [
            SettingsSection(
              // title: '',
              tiles: [
                SettingsTile(
                  title: 'Tax rate',
                  leading: Icon(Icons.calculate_outlined),
                  subtitle: (taxRate != '') ? '$taxRate%' : 'Not set',
                  onPressed: (context) {
                    _taxRateDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _taxRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tax rate'),
          content: TextFormField(
            controller: taxRateController,
            keyboardType: TextInputType.number,
            autofocus: true,
            // Only allow entry numbers in double format.
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            ],
            decoration: InputDecoration(hintText: 'Eg.: 13%'),
            onFieldSubmitted: (value) => _setStringPref(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _setStringPref(),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _setStringPref() {
    prefs.setString('taxRate', taxRateController.text);
    taxRate = taxRateController.text;
    setState(() => Navigator.pop(context));
  }
}
