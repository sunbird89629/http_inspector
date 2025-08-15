import 'package:http_inspector/src/interceptors/http_scope_view_config.dart';
import 'package:http_inspector/src/loggers/fancy_dio_logger.dart';
import 'package:http_inspector/src/providers/main_data_provider.dart';
import 'package:http_inspector/src/ui/widgets/http_record_item_widget.dart';
import 'package:http_inspector/src/ui/widgets/title_bar_action_widget.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

final mainDataProvider = MainDataProvider(
  httpRecords: FancyDioLogger.instance.records,
);

class HttpScopeView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Theme(
      data: context.currentTheme,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ListenableBuilder(
            listenable: mainDataProvider,
            builder: (context, child) {
              return Text(
                'HttpRecords( ${mainDataProvider.httpRecords.length} )',
              );
            },
          ),
          // bottom: TabBar(tabs: tabs),
          leading: leading,
          actions: [
            TitleBarActionWidget(
              iconData: Icons.help_outline,
              onPressed: () async {
                final url = viewConfig.manualUrl ??
                    'https://github.com/sunbird89629/fancy_dio_inspector/blob/main/docs/manual.md';
                final opener = viewConfig.onOpenManual;
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
        final httpRecords = mainDataProvider.httpRecords
            .where(
              (record) => viewConfig.recordFilter?.call(record) ?? true,
            )
            .toList();

        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            height: 3,
            thickness: 1,
            color: Color.fromARGB(255, 238, 235, 239),
            indent: 30,
            endIndent: 20,
          ),
          itemCount: httpRecords.length,
          itemBuilder: (context, index) {
            final model = httpRecords[index];
            return HttpRecordItemWidget(model: model);
          },
        );
      },
    );
    // return ValueListenableBuilder<List<HttpRecord>>(
    //   valueListenable: httpRecords,
    //   builder: (
    //     context,
    //     value,
    //     child,
    //   ) {
    //     return ListView.separated(
    //       separatorBuilder: (context, index) => const Divider(
    //         height: 3,
    //         thickness: 1,
    //         color: Color.fromARGB(255, 238, 235, 239),
    //         indent: 20,
    //         endIndent: 12,
    //       ),
    //       itemCount: value.length,
    //       itemBuilder: (context, index) {
    //         final model = value[index];
    //         return HttpRecordItemWidget(model: model);
    //       },
    //     );
    //   },
    // );
  }
}
