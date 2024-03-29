import 'package:flutter/material.dart';

import '../../../domain/core/core.dart';
import '../../../presentation/core/core.dart';
import '../pages/item_details_page.dart';

class FloatingDoneButton extends StatelessWidget {
  const FloatingDoneButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Done'),
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
