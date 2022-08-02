import 'package:flutter/material.dart';

/// Display a tooltip with a single tap or click,
/// where the default widget requires a long press / long click.
class SimpleTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  SimpleTooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  final _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dynamic toolTip = _toolTipKey.currentState;
        toolTip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: _toolTipKey,
        message: message,
        child: child,
      ),
    );
  }
}
