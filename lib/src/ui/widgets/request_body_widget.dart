import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/title_content_pannel_widget.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';

class RequestBodyWidget extends StatelessWidget {
  const RequestBodyWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;

  @override
  Widget build(BuildContext context) {
    final data = model.requestOptions.data;

    if (data == null) {
      return const SizedBox.shrink();
    }

    String content;
    if (data is Map<String, dynamic>) {
      content = data.toPrettyJson();
    } else {
      content = data.toString();
    }

    return TitleContentPannelWidget(
      title: 'Request Body',
      content: content,
    );
  }
}
