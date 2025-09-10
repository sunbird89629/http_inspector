import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/title_content_pannel_widget.dart';

class ResponseBodyWidget extends StatelessWidget {
  const ResponseBodyWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;
  @override
  Widget build(BuildContext context) {
    return TitleContentPannelWidget(
      title: 'Response Body ( ${model.contentType} )',
      content: model.responseBodyPrettyJson,
    );
  }
}
