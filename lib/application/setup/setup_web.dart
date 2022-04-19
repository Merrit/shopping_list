import 'package:universal_html/html.dart';

import 'setup.dart';

Setup getSetup() => WebSetup();

/// Disable right-click on Web platform.
///
/// This allows us to show a custom right-click
/// menu in the style of a desktop application.
class WebSetup implements Setup {
  @override
  void init() => _disableWebRightClick();

  void _disableWebRightClick() {
    document.onContextMenu.listen((event) => event.preventDefault());
  }
}
