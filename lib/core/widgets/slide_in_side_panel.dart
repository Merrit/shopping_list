import 'package:flutter/material.dart';

void showSlideInSidePanel({
  required BuildContext context,
  required Widget child,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'slideInSidePanelBarrier',
    pageBuilder: (context, animation, secondaryAnimation) {
      return SlideInSidePanel(child: child);
    },
  );
}

class SlideInSidePanel extends StatelessWidget {
  final Widget child;

  const SlideInSidePanel({
    Key? key,
    required this.child,
  }) : super(key: key);

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            var width = (constraints.maxWidth > 600) ? 0.4 : 0.85;

            return Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: width,
                child: Container(
                  height: double.infinity,
                  child: Card(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(12.0),
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
