import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/title_content_pannel_widget.dart';
import 'package:flutter/material.dart';

class ResponseHeaderWidget extends StatelessWidget {
  const ResponseHeaderWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;
  @override
  Widget build(BuildContext context) {
    final headers = model.response?.headers.map ?? model.dioException?.response?.headers.map;

    if (headers == null) {
      return const SizedBox.shrink();
    }

    return TitleContentPannelWidget(
      title: 'Response Headers',
      contentWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headers.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e.key}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    e.value.join(', '),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
