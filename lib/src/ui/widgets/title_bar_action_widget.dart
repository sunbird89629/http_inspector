import 'package:flutter/material.dart';

class TitleBarActionWidget extends StatelessWidget {
  const TitleBarActionWidget({
    required this.iconData,
    super.key,
    this.onPressed,
    this.onLongPress,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      icon: Icon(iconData),
    );
  }
}
