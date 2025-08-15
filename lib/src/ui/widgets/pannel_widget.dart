import 'package:flutter/material.dart';

class PannelWidget extends StatelessWidget {
  const PannelWidget({
    required this.content,
    required this.title,
    super.key,
  });
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xffFEF7FF),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          content,
        ],
      ),
    );
  }
}
