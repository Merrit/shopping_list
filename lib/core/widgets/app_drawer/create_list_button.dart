import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/validators/validators.dart';
import 'package:shopping_list/home/home.dart';

class CreateListButton extends StatelessWidget {
  const CreateListButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => _showCreateListDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create list',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

Future<void> _showCreateListDialog(BuildContext context) async {
  String? newListName;
  await showDialog(
    context: context,
    builder: (context) {
      final _controller = TextEditingController();
      return AlertDialog(
        title: Text('Create list'),
        content: TextField(
          controller: _controller,
          autofocus: platformIsWebMobile(context) ? false : true,
          decoration: InputDecoration(
            hintText: 'Name',
          ),
          onSubmitted: (_) {
            print('submitted');
            newListName = _controller.value.text;
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              newListName = _controller.value.text;
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
  context.read<HomeCubit>().createList(name: newListName);
}
