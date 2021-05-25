import 'package:flutter/material.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/shopping_list/item_details/item_details.dart';

class FloatingDoneButton extends StatelessWidget {
  const FloatingDoneButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Done'),
        onPressed: () {
          // On handsets we go back to item details,
          // on larger screens that show 2 colums we
          // go back to the main page.
          final formFactor = getFormFactor(context);
          if (formFactor == FormFactor.handset) {
            Navigator.pop(context);
          } else {
            ItemDetailsPage.popItemDetails(context);
          }
        },
      ),
    );
  }
}
