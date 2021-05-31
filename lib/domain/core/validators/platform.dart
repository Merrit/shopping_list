import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool platformIsWebMobile(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final isMobile = (mediaQuery.size.width <= 600);
  if (kIsWeb && isMobile) {
    return true;
  } else {
    return false;
  }
}
