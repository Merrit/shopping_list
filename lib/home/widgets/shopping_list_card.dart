import 'package:flutter/material.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCard({
    required Key key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          ShoppingListPage.id,
          arguments: list.id,
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(list.name),
          ],
        ),
      ),
    );
  }
}
