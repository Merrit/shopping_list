import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  int itemCount;
  List<String> listItems = ['Test1', 'Test2'];

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
                children: [
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                  Text(
                    'Test',
                    textScaleFactor: 5,
                  ),
                ],
              ),
            ),
          ),
          ModalBottomSheetLauncher(),
        ],
      ),
    );
  }
}

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
