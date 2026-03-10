import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/providers/main_provider.dart';
import 'package:http_inspector/src/theme/fancy_colors.dart';
import 'package:http_inspector/src/ui/views/edit_request_page.dart';
import 'package:http_inspector/src/ui/widgets/curl_widget.dart';
import 'package:http_inspector/src/ui/widgets/error_body_widget.dart';
import 'package:http_inspector/src/ui/widgets/overview_widget.dart';
import 'package:http_inspector/src/ui/widgets/request_body_widget.dart';
import 'package:http_inspector/src/ui/widgets/request_header_widget.dart';
import 'package:http_inspector/src/ui/widgets/response_body_widget.dart';
import 'package:http_inspector/src/ui/widgets/response_header_widget.dart';
import 'package:http_inspector/src/ui/widgets/title_bar_action_widget.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';

class HttpDetailPage extends StatelessWidget {
  const HttpDetailPage({
    required this.model,
    super.key,
    this.themeData,
  });
  final ThemeData? themeData;

  final HttpRecord model;

  Color get _statusColor {
    switch (model.statusCode) {
      case 200:
        return FancyColors.green;
      case null:
        return FancyColors.yellow;
      default:
        return FancyColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shareAction = MainProvider().viewConfig.onShareAction;

    return Theme(
      data: themeData ?? context.currentTheme,
      child: Scaffold(
        backgroundColor: FancyColors.grey,
        appBar: AppBar(
          backgroundColor: _statusColor,
          centerTitle: true,
          title: Text(model.requestOptions.uri.pathSegments.last),
          actions: [
            TitleBarActionWidget(
              iconData: Icons.edit,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditRequestPage(record: model),
                  ),
                );
              },
            ),
            TitleBarActionWidget(
              iconData: Icons.copy,
              onPressed: () {
                final content = model.toHttpRequestLog();
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('HTTP log copied to clipboard!'),
                  ),
                );
              },
            ),
            if (shareAction != null)
              TitleBarActionWidget(
                iconData: Icons.share,
                onPressed: () => shareAction(model),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: ColoredBox(
            color: const Color.fromARGB(255, 238, 235, 239),
            child: Column(
              spacing: 8,
              children: [
                OverviewWidget(model: model),
                _buildResultWidget(),
                CurlWidget(model: model),
                RequestHeaderWidget(model: model),
                RequestBodyWidget(model: model),
                ResponseHeaderWidget(model: model),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    if (model.response != null) {
      return ResponseBodyWidget(model: model);
    } else if (model.exception != null) {
      return ErrorBodyWidget(model: model);
    } else {
      return const SizedBox.shrink();
    }
  }
}
