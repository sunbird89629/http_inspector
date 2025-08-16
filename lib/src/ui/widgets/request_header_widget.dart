import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/title_content_pannel_widget.dart';
import 'package:flutter/material.dart';

class RequestHeaderWidget extends StatelessWidget {
  const RequestHeaderWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;

  @override
  Widget build(BuildContext context) {
    final headers = model.requestOptions.headers;

    return TitleContentPannelWidget(
      title: 'Request Headers',
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
                    e.value.toString(),
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
