import 'package:flutter/material.dart';

class CheckboxLarge extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const CheckboxLarge({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.6,
      child: Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        value: value,
        onChanged: (newValue) => onChanged(value),
      ),
    );
  }
}
