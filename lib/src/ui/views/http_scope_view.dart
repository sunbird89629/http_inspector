import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_inspector/src/interceptors/http_scope_view_config.dart';
import 'package:http_inspector/src/loggers/fancy_dio_logger.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/providers/main_data_provider.dart';
import 'package:http_inspector/src/ui/widgets/http_record_item_widget.dart';
import 'package:http_inspector/src/ui/widgets/title_bar_action_widget.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

final mainDataProvider = MainDataProvider(
  httpRecords: FancyDioLogger.instance.records,
);

class HttpScopeView extends StatefulWidget {
  /// The options for the dio tiles.
  /// If this is `null`, the default options will be used.
  // final FancyDioInspectorTileOptions tileOptions;

  /// The options for the UI localization.
  /// If any of the value is `null`, the default value will be used.
  // final FancyDioInspectorL10nOptions l10nOptions;

  /// [leading] is used to place a widget before the title.
  final Widget? leading;

  /// [actions] are used to place widgets after the title.
  final List<Widget>? actions;

  /// The theme data for the view. If this is `null`, `FancyThemeData` will be
  /// used.
  // final ThemeData? themeData;

  final HttpScopeViewConfig viewConfig;

  const HttpScopeView({
    super.key,
    this.leading,
    this.actions,
    // this.themeData,
    this.viewConfig = const HttpScopeViewConfig(),
  });

  @override
  State<HttpScopeView> createState() => _HttpScopeViewState();
}

class _HttpScopeViewState extends State<HttpScopeView> {
  bool _showOnlyFavorites = false;
  bool _isSearch = false;
  final _searchController = TextEditingController();
  String? _domainFilter;
  final _domainFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _domainFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.currentTheme,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _isSearch
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                )
              : ListenableBuilder(
                  listenable: mainDataProvider,
                  builder: (context, child) {
                    return Text(
                      'HttpRecords( ${mainDataProvider.httpRecords.length} )',
                    );
                  },
                ),
          // bottom: TabBar(tabs: tabs),
          leading: widget.leading,
          actions: [
            TitleBarActionWidget(
              iconData: Icons.filter_alt,
              onPressed: _showDomainFilterDialog,
            ),
            TitleBarActionWidget(
              iconData: Icons.search,
              onPressed: () {
                setState(() {
                  _isSearch = !_isSearch;
                  if (!_isSearch) {
                    _searchController.clear();
                  }
                });
              },
            ),
            TitleBarActionWidget(
              iconData: _showOnlyFavorites ? Icons.star : Icons.star_border,
              onPressed: () {
                setState(() {
                  _showOnlyFavorites = !_showOnlyFavorites;
                });
              },
            ),
            TitleBarActionWidget(
              iconData: Icons.help_outline,
              onPressed: () async {
                final url = widget.viewConfig.manualUrl ??
                    'https://github.com/sunbird89629/fancy_dio_inspector/blob/main/docs/manual.md';
                final opener = widget.viewConfig.onOpenManual;
                if (opener != null) {
                  opener(url);
                  return;
                }

                // Capture navigation and messenger before async gaps to avoid
                // using BuildContext across async boundaries.
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                // Try to open with url_launcher first
                final uri = Uri.parse(url);
                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );

                if (!launched) {
                  if (!navigator.mounted) return;
                  // Fallback: show dialog with copy-to-clipboard
                  // ignore: use_build_context_synchronously
                  await showDialog<void>(
                    context: navigator.context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('打开使用手册'),
                        content: SelectableText(url),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: url));
                              Navigator.of(ctx).pop();
                              messenger.showSnackBar(
                                const SnackBar(content: Text('链接已复制')),
                              );
                            },
                            child: const Text('复制链接'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('关闭'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TitleBarActionWidget(
              iconData: Icons.tune,
              onPressed: () {},
            ),
            TitleBarActionWidget(
              iconData: Icons.clear_all,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请长按以清空历史记录'),
                    duration: Duration(seconds: 3),
                  ),
                );
                // ScaffoldMessenger.of(context).showMaterialBanner(
                //   const MaterialBanner(
                //     content: Text('为防止误触，请长按以删除历史记录'),
                //     actions: [
                //       SizedBox.shrink(),
                //     ],
                //   ),
                // );
              },
              onLongPress: () {
                FancyDioLogger.instance.records.clear();
                mainDataProvider.httpRecords = FancyDioLogger.instance.records;
              },
            ),
          ],
        ),
        // body: TabBarView(children: tabBarViews),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ListenableBuilder(
      listenable: mainDataProvider,
      builder: (context, child) {
        final httpRecords = mainDataProvider.httpRecords.where(
          (record) {
            final filter = widget.viewConfig.recordFilter?.call(record) ?? true;
            final favorite = !_showOnlyFavorites || record.isFavorite;
            final search = _searchController.text.isEmpty ||
                record.requestOptions.uri
                    .toString()
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase());
            final domain = _domainFilter == null ||
                record.requestOptions.uri.host
                    .toLowerCase()
                    .contains(_domainFilter!.toLowerCase());
            return filter && favorite && search && domain;
          },
        ).toList();

        final groupedRecords = groupBy<HttpRecord, String>(
          httpRecords,
          (record) => record.startTime?.formattedHourMinuteString() ?? '',
        );

        return ListView.builder(
          itemCount: groupedRecords.length,
          itemBuilder: (context, index) {
            final key = groupedRecords.keys.elementAt(index);
            final records = groupedRecords[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (key.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      key,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(
                    height: 3,
                    thickness: 1,
                    color: Color.fromARGB(255, 238, 235, 239),
                    indent: 30,
                    endIndent: 20,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final model = records[index];
                    return HttpRecordItemWidget(model: model);
                  },
                ),
              ],
            );
          },
        );
      },
    );
    // return ValueListenableBuilder<List<HttpRecord>>(...)
  }

  void _showDomainFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by domain'),
          content: TextField(
            controller: _domainFilterController,
            decoration: const InputDecoration(hintText: 'e.g., google.com'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _domainFilter = null;
                  _domainFilterController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _domainFilter = _domainFilterController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
