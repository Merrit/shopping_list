import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final void Function(String value) onChanged;
  final Widget? child;
  final String hintText;
  final String label;

  SettingsTile({
    Key? key,
    required this.onChanged,
    this.child,
    this.hintText = '',
    this.label = '',
  }) : super(key: key);

  // SettingsTile.custom({
  //   Key? key,
  //   required this.onChanged,
  //   required this.child,
  //   this.hintText = '',
  //   this.label = '',
  // }) : super(key: key);

  late final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller.text = hintText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        Focus(
            focusNode: _focusNode,
            child: child ??
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                  onChanged: (value) => onChanged(value),
                )),
      ],
    );
  }
}
