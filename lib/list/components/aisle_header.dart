import 'package:flutter/material.dart';

class AisleHeader extends StatelessWidget {
  final String aisle;

  AisleHeader({@required this.aisle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(aisle),
        onPressed: () {},
      ),
    );
  }
}
