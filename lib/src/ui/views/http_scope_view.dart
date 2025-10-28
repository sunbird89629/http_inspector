import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http_inspector/http_inspector.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/providers/main_provider.dart';
import 'package:http_inspector/src/ui/widgets/title_bar_action_widget.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpScopeView extends StatefulWidget {
  final Widget? leading;

  final List<Widget>? actions;

  final HttpScopeViewConfig viewConfig;

  const HttpScopeView({
    super.key,
    this.leading,
    this.actions,
    this.viewConfig = const HttpScopeViewConfig(),
  });

  @override
  State<HttpScopeView> createState() => _HttpScopeViewState();
}

class _HttpScopeViewState extends State<HttpScopeView> {
  bool _showOnlyFavorites = false;
  final bool _isSearch = false;
  final _searchController = TextEditingController();
  final _domainFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MainProvider().viewConfig = widget.viewConfig;
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
        appBar: _buildAppBar(context),
        // body: TabBarView(children: tabBarViews),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
              listenable: MainProvider(),
              builder: (context, child) {
                return Text(
                  'HttpRecords( ${MainProvider().httpRecords.length} )',
                );
              },
            ),
      // bottom: TabBar(tabs: tabs),
      leading: widget.leading,
      actions: [
        TitleBarActionWidget(
          iconData: _showOnlyFavorites ? Icons.star : Icons.star_border,
          onPressed: () {
            setState(() {
              _showOnlyFavorites = !_showOnlyFavorites;
            });
          },
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
          },
          onLongPress: () {
            MainProvider().updateHttpRecords(
              (records) => records.removeWhere(
                (record) => !record.isFavorite && !record.isAlwaysStar,
              ),
            );
          },
        ),
        TitleBarActionWidget(
          iconData: Icons.help_outline,
          onPressed: () {
            const url = 'https://sunbird89629.github.io/http_inspector/manual';
            final uri = Uri.parse(url);
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }

  List<HttpRecord> get recordsShouldToShow {
    final httpRecords = MainProvider().httpRecords.where(
      (record) {
        final filter = MainProvider().viewConfig.recordFilter.call(record);
        final favorite =
            !_showOnlyFavorites || record.isFavorite || record.isAlwaysStar;
        // final search = _searchController.text.isEmpty ||
        //     record.requestOptions.uri
        //         .toString()
        //         .toLowerCase()
        //         .contains(_searchController.text.toLowerCase());
        // final domain = _domainFilter == null ||
        //     record.requestOptions.uri.host
        //         .toLowerCase()
        //         .contains(_domainFilter!.toLowerCase());
        // return filter && favorite && search && domain;
        return filter && favorite;
      },
    ).toList();
    return httpRecords;
  }

  Widget _buildBody() {
    return ListenableBuilder(
      listenable: MainProvider(),
      builder: (context, child) {
        final groupedRecords = groupBy<HttpRecord, String>(
          recordsShouldToShow,
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
                    // return HttpRecordItemWidget(model: model);
                    return widget.viewConfig.itemBuilder(context, model);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
