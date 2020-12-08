import 'package:shopping_list/list/item.dart';

class SubItem extends Item {
  SubItem({String subItemName, int amount = 0})
      : super(itemName: subItemName, amount: amount);
}
