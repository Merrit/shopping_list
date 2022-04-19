import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsTile extends StatelessWidget {
  final void Function(String value) onChanged;
  final Widget? child;
  final String defaultText;
  final String hintText;
  final Widget label;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLines;

  SettingsTile({
    Key? key,
    required this.onChanged,
    this.child,
    this.defaultText = '',
    this.hintText = '',
    this.label = const Text(''),
    this.inputFormatters,
    this.keyboardType,
    this.maxLines,
  }) : super(key: key);

  late final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller.text = defaultText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        const SizedBox(height: 10),
        Focus(
            focusNode: _focusNode,
            child: child ??
                TextField(
                  maxLines: maxLines,
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
