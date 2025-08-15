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
    return TitleContentPannelWidget(
      title: 'Request Headers',
      content: model.requestOptions.headers.toString(),
    );
  }
}
