import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/title_content_pannel_widget.dart';
import 'package:http_inspector/src/utils/extensions/request_extensions.dart';
import 'package:flutter/material.dart';

class CurlWidget extends StatelessWidget {
  const CurlWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;
  @override
  Widget build(BuildContext context) {
    return TitleContentPannelWidget(
      title: 'CURL',
      content: model.requestOptions.cURL,
    );
  }
}
