import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/ui/widgets/pannel_widget.dart';
import 'package:flutter/material.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;

  @override
  Widget build(BuildContext context) {
    final queryParameters = model.requestOptions.uri.queryParametersAll;

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
            'Overview',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.requestOptions.method,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              model.requestOptions.uri.origin + model.requestOptions.uri.path,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (queryParameters.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildQueryParameters(context, queryParameters),
            ],
            Text(
              model.requestOptions.contentType ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryParameters(
    BuildContext context,
    Map<String, List<String>> queryParameters,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Query Parameters',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...queryParameters.entries.map((e) {
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
      ],
    );
  }
}
