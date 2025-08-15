import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/ui/views/http_detail_page.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class HttpRecordItemWidget extends StatelessWidget {
  const HttpRecordItemWidget({
    required this.model,
    super.key,
  });

  final HttpRecord model;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffFEF7FF),
      child: ListTile(
        leading: Container(
          width: 4,
          color: model.statusColor,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                model.requestOptions.method,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Text(
              model.statusCode.toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FancyColors.blue,
                  ),
            ),
            const SizedBox(width: 20),
            Text(
              model.startTime?.formattedTimeString() ?? '',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FancyColors.yellow,
                  ),
            ),
            const SizedBox(width: 20),
            Text(
              model.duration,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FancyColors.pink,
                  ),
            ),
          ],
        ),
        subtitle: Text(
          model.requestOptions.uri.path,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        contentPadding: const EdgeInsets.only(right: 2),
        minLeadingWidth: 8,
        onTap: () {
          // 假设你有一个详情页，比如 NetworkDetailPage
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HttpDetailPage(model: model),
            ),
          );
        },
      ),
    );
  }
}
