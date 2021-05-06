import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Object?> showSlideInSidePanel({
  required BuildContext context,
  required Widget child,
  List<BlocProvider> providers = const [],
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'slideInSidePanelBarrier',
    pageBuilder: (context, animation, secondaryAnimation) {
      if (providers.isNotEmpty) {
        return MultiBlocProvider(
          providers: providers,
          child: SlideInSidePanel(child: child),
        );
      } else {
        return SlideInSidePanel(child: child);
      }
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
                    child: child,
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
