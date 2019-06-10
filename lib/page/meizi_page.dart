import 'package:flutter/material.dart';
import 'dart:async';
import '../util/data_util.dart';
import '../model/gank_info.dart';
import '../model/empty_view_status.dart';
import '../widget/meizi_list_item.dart';
import '../widget/load_more_view.dart';
import '../widget/empty_view.dart';
import '../widget/smart_listview.dart';

class MeiZiPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeiZiPageState();
}
///妹子页面
class _MeiZiPageState extends State<MeiZiPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNo = 1;
  bool _isLoadMore = false;
  bool _hasMore = false;
  List<GankInfo> _gankInfos = [];
  ScrollController _scrollController;

  // 默认Loading
  EmptyViewStatus _emptyViewStatus = EmptyViewStatus.loading;

  @override
  void initState() {
    super.initState();
    _initController();
    _loadData();
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

  Future<void> _loadData() async {
    _isLoadMore ? _pageNo++ : _pageNo = 1;
    await DataUtil.getCategoryData('福利', _pageNo).then((resultList) {
      setState(() {
        _gankInfos.addAll(resultList);
        _hasMore = resultList.isNotEmpty;

        _emptyViewStatus = _pageNo == 1 && _gankInfos.isEmpty
            ? EmptyViewStatus.noData
            : EmptyViewStatus.hasData;
      });
    });
  }

  Future<void> _onRefresh() async {
    _isLoadMore = false;
    _gankInfos.clear();
    await _loadData();
    return null;
  }

  Future<void> _onLoadMore() async {
    _isLoadMore = true;
    await _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _renderList(int index) {
    if (index == _gankInfos.length) {
      return new LoadMoreView(_hasMore);
    }
    return new MeiZiListItem(_gankInfos[index].url, currentIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new SmartListView(
        datas: this._gankInfos,
        emptyViewStatus: this._emptyViewStatus,
        backgroundColor: Colors.white,
        renderList: (index) => this._renderList(index),
        onrefresh: () async => this._onRefresh(),
        onLoadMore: () async => this._onLoadMore());
  }

  @override
  bool get wantKeepAlive => true;
}
