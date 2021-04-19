import 'package:flutter/material.dart';

class CreateListDialog extends StatefulWidget {
  final void Function(String name) callback;

  CreateListDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  _CreateListDialogState createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'List Name',
        ),
        onChanged: (_) => setState(() {}),
        onFieldSubmitted:
            _controller.value.text != '' ? (_) => _createList(context) : null,
      ),
      actions: [
        TextButton(
          onPressed:
              _controller.value.text != '' ? () => _createList(context) : null,
          child: Text('Create'),
        ),
      ],
    );
  }

  void _createList(BuildContext context) {
    widget.callback(_controller.value.text);
    Navigator.pop(context);
  }
}
