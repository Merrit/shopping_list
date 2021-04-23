import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class SettingsTile extends StatelessWidget {
  final void Function(String value) onSubmitted;
  final String label;
  final String title;

  SettingsTile({
    Key? key,
    required this.onSubmitted,
    this.label = '',
    this.title = '',
  }) : super(key: key);

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _controller.text = title;
    return ChangeNotifierProvider(
      create: (context) => SettingsTileState(),
      builder: (context, child) {
        final state = context.watch<SettingsTileState>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            SizedBox(height: 10),
            Focus(
              focusNode: _focusNode,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: title,
                  suffixIcon: (state.hasChanged)
                      ? IconButton(
                          onPressed: () => _submit(state),
                          icon: Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        )
                      : null,
                ),
                onChanged: (_) => state.setChanged(true),
                onSubmitted: (value) => _submit(state),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submit(SettingsTileState state) {
    onSubmitted(_controller.value.text);
    state.setChanged(false);
    _focusNode.unfocus();
  }
}
