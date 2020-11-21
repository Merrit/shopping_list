import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  int itemCount;
  List<Widget> listItems = [ListItem()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 8.0,
                bottom: 2.0,
              ),
              child: ListView(
                children: listItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final itemColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        color: itemColor,
        height: 35,
        width: double.infinity,
      ),
    );
  }
}

_showDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Reset settings?'),
            content: Text(
                'This will reset your device to its default factory settings.'),
            actions: [
              FlatButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {},
                child: Text('CANCEL'),
              ),
              FlatButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {},
                child: Text('ACCEPT'),
              ),
            ],
          ));
}
