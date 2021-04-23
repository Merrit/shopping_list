import 'package:flutter/material.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

class ItemDetailsPage extends StatefulWidget {
  static const id = 'item_details_page';

  final Item item;

  const ItemDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<bool> _onWillPop() async {
    if (item == widget.item) {
      return true;
    } else {
      // Return the modified item.
      Navigator.pop(context, item);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: ListView(
            padding: const EdgeInsets.all(40),
            children: [
              SettingsTile(
                label: 'Name',
                title: item.name,
                onSubmitted: (value) => item = item.copyWith(name: value),
              ),
              SizedBox(height: 40),
              SettingsTile(
                label: 'Quantity',
                title: item.quantity,
                onSubmitted: (value) => item = item.copyWith(quantity: value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
