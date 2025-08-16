import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/ui/widgets/pannel_widget.dart';
import 'package:flutter/material.dart';

class TitleContentPannelWidget extends StatelessWidget {
  const TitleContentPannelWidget({
    required this.title,
    this.content,
    this.contentWidget,
    super.key,
  }) : assert(content != null || contentWidget != null);
  final String title;
  final String? content;
  final Widget? contentWidget;

  @override
  Widget build(BuildContext context) {
    return PannelWidget(
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 4,
            color: FancyColors.turquoise,
            height: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: contentWidget ??
            Text(
              content!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
      ),
    );
  }
}
