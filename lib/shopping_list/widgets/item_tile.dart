import 'package:flutter/material.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text('2'),
              backgroundColor: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
