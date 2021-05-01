import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsTile extends StatelessWidget {
  final void Function(String value) onChanged;
  final Widget? child;
  final String defaultText;
  final String hintText;
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  SettingsTile({
    Key? key,
    required this.onChanged,
    this.child,
    this.defaultText = '',
    this.hintText = '',
    this.label = '',
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  late final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller.text = defaultText;
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
                  inputFormatters: inputFormatters,
                  keyboardType: keyboardType,
                  onChanged: (value) => onChanged(value),
                )),
      ],
    );
  }
}
