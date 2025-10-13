import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/ui/views/http_detail_page.dart';
import 'package:http_inspector/src/ui/views/http_scope_view.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';
import 'package:http_inspector/src/utils/extensions/scope_extensions.dart';

class HttpRecordItemWidget extends StatefulWidget {
  const HttpRecordItemWidget({
    required this.record,
    super.key,
  });

  final HttpRecord record;

  @override
  State<HttpRecordItemWidget> createState() => _HttpRecordItemWidgetState();
}

class _HttpRecordItemWidgetState extends State<HttpRecordItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffFEF7FF),
      child: ListTile(
        leading: Container(
          width: 4,
          color: widget.record.statusColor,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                widget.record.requestOptions.method,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Text(
              widget.record.statusCode.toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FancyColors.blue,
                  ),
            ),
            const SizedBox(width: 20),
            Text(
              widget.record.startTime?.formattedTimeString() ?? '',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FancyColors.yellow,
                  ),
            ),
            const SizedBox(width: 20),
            buildDurationWidget(context),
          ],
        ),
        subtitle: Text(
          widget.record.requestOptions.uri.path,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStarWidget(),
            const Icon(Icons.keyboard_arrow_right),
          ],
        ),
        contentPadding: const EdgeInsets.only(right: 2),
        minLeadingWidth: 8,
        onTap: () {
          // 假设你有一个详情页，比如 NetworkDetailPage
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HttpDetailPage(model: widget.record),
            ),
          );
        },
      ),
    );
  }

  IconButton _buildStarWidget() {
    final iconStar = widget.record.run((it) {
      if (it.isAlwaysStar) {
        return Icons.stars;
      } else if (it.isFavorite) {
        return Icons.star;
      } else {
        return Icons.star_border;
      }
    });

    return IconButton(
      icon: Icon(
        iconStar,
        color: widget.record.isFavorite || widget.record.isAlwaysStar
            ? Colors.amber
            : null,
      ),
      onPressed: () {
        setState(() {
          widget.record.isFavorite = !widget.record.isFavorite;
        });
        mainDataProvider.notifyListeners();
      },
    );
  }

  Row buildDurationWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.record.duration,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: FancyColors.pink,
              ),
        ),
        Text(
          'ms',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: FancyColors.pink,
              ),
        ),
      ],
    );
  }
}
