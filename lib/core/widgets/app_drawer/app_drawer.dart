import 'package:flutter/material.dart';

import 'bottom_buttons.dart';
import 'create_list_button.dart';
import 'scrolling_list_names.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CreateListButton(),
        const ScrollingListNames(),
        const BottomButtons(),
      ],
    );
  }
}
