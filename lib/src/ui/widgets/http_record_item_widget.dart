import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/providers/main_provider.dart';
import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/ui/views/http_detail_page.dart';
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
  bool get _isAlwaysStar =>
      MainProvider().viewConfig.alwaysStar(widget.record);

  Color get _statusColor {
    switch (widget.record.statusCode) {
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
    return ColoredBox(
      color: const Color(0xffFEF7FF),
      child: ListTile(
        leading: Container(
          width: 4,
          color: _statusColor,
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
            _buildDurationWidget(context),
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
            if (widget.record.isRequesting)
              _buildLoadingIndicator()
            else
              _buildStarWidget(),
            const Icon(Icons.keyboard_arrow_right),
          ],
        ),
        contentPadding: const EdgeInsets.only(right: 2),
        minLeadingWidth: 8,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HttpDetailPage(model: widget.record),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      constraints: BoxConstraints.tight(const Size(20, 20)),
      margin: const EdgeInsets.only(right: 12),
      child: const CircularProgressIndicator.adaptive(),
    );
  }

  IconButton _buildStarWidget() {
    final isAlwaysStar = _isAlwaysStar;
    final isFavorite = widget.record.isFavorite;

    final iconStar = widget.record.run((_) {
      if (isAlwaysStar) return Icons.stars;
      if (isFavorite) return Icons.star;
      return Icons.star_border;
    });

    return IconButton(
      icon: Icon(
        iconStar,
        color: isFavorite || isAlwaysStar ? Colors.amber : null,
      ),
      onPressed: () {
        MainProvider().updateHttpRecord(() {
          widget.record.isFavorite = !widget.record.isFavorite;
        });
      },
    );
  }

  Row _buildDurationWidget(BuildContext context) {
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
