import 'package:flutter/material.dart';
import 'package:shopping_list/list/screens/aisles_screen.dart';

Future<String> setAisle(BuildContext context) async {
  var _aisle = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AislesScreen()),
  );

  return _aisle ?? 'Unsorted';
}
