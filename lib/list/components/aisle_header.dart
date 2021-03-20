import 'package:flutter/material.dart';

class AisleHeader extends StatelessWidget {
  final String aisle;

  AisleHeader({@required this.aisle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(
          aisle,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }
}
