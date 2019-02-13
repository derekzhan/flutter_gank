import 'package:flutter/material.dart';
import '../util/data_util.dart';
import '../model/history_content_info.dart';
import '../model/empty_view_status.dart';
import '../widget/load_more_view.dart';
import '../widget/history_content_list_item.dart';
import '../widget/smart_listview.dart';
import '../page/detail_page.dart';
import 'dart:async';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final int _pageCount = 20;
  int _pageNum = 1;
  bool _isLoadMore = false;
  bool _hasMore = false;
  List<HistoryContentInfo> _historyList = [];
  ScrollController _scrollController;

// 默认Loading
  EmptyViewStatus _emptyViewStatus = EmptyViewStatus.loading;

  @override
  void initState() {
    super.initState();
    _initController();
    _initLoad();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _initController() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onLoadMore();
      }
    });
  }

  Future<void> _initLoad() async {
    if (_isLoadMore) {
      _pageNum += 1;
    } else {
      _pageNum = 1;
    }
    await DataUtil.getHistoryContentData(_pageNum, count: _pageCount)
        .then((resultList) {
      setState(() {
        _historyList.addAll(resultList);
        _hasMore = resultList.length >= _pageCount;

        _emptyViewStatus = _historyList.isEmpty && _pageNum == 1
            ? EmptyViewStatus.noData
            : EmptyViewStatus.hasData;
      });
    });
  }

  Future<void> _onRefresh() async {
    _historyList.clear();
    _isLoadMore = false;
    await _initLoad();
  }

  Future<void> _onLoadMore() async {
    if (_hasMore) {
      _isLoadMore = true;
      await _initLoad();
    }
  }

  void _itemTap(BuildContext context, String date) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => new DetailPage(date)));

  Widget _renderList(BuildContext context, int index) {
    if (index == _historyList.length) {
      return new LoadMoreView(_hasMore);
    }
    return new HistoryContentListItem(_historyList[index], onTap: _itemTap);
  }

  @override
  Widget build(BuildContext context) {
    final Widget appBar = new AppBar(
      title: const Text('干货历史'),
      leading: const BackButton(),
    );

    final Widget body = new SmartListView(
        datas: this._historyList,
        emptyViewStatus: this._emptyViewStatus,
        renderList: (index) => this._renderList(context, index),
        onrefresh: () async => this._onRefresh(),
        onLoadMore: () async => this._onLoadMore());

    return new Scaffold(appBar: appBar, body: body);
  }
}
