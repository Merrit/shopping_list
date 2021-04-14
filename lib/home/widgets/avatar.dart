import 'package:flutter/material.dart';

const _avatarSize = 48.0;

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _avatarSize,
      child: const Icon(Icons.person_outline, size: _avatarSize),
    );
  }
}
