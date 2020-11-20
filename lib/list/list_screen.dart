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
          // ModalBottomSheetLauncher(),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  var itemColor = Colors.blue;

  var myDiag = AlertDialog(
    title: Text('Reset settings?'),
    content:
        Text('This will reset your device to its default factory settings.'),
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
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: itemColor,
        height: 35,
        width: double.infinity,
      ),
    );
  }
}

/* 
() async {
        await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Message'),
            content: Text('Your file is saved.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: new Text('OK'),
              ),
            ],
          ),
        );
      } */

/* 
class ModalBottomSheetLauncher extends StatelessWidget {
  const ModalBottomSheetLauncher({
    Key key,
  }) : super(key: key);

  static const BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: bottomSheetDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text('New Item'),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return ShoppingModalBottomSheet(
                bottomSheetDecoration: bottomSheetDecoration,
              );
            });
      },
    );
  }
}

class ShoppingModalBottomSheet extends StatelessWidget {
  const ShoppingModalBottomSheet({
    Key key,
    this.bottomSheetDecoration,
  }) : super(key: key);

  final BoxDecoration bottomSheetDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bottomSheetDecoration,
      height: 500,
      child: Column(
        children: [
          TextField(),
        ],
      ),
    );
  }
}
 */
