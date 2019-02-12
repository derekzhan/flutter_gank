import 'package:flutter/material.dart';
import './empty_view.dart';
import '../model/empty_view_status.dart';

/// 缺省、下拉刷新、上拉加载封装
class SmartRefreshListView extends StatefulWidget {
  // 数据列表
  final List<Object> datas;

  // 缺省View状态
  final EmptyViewStatus emptyViewStatus;

  // 渲染回调
  final Function(int) renderList;

  // 刷新回调
  final Future<void> Function() onrefresh;

  // 加载更多回调
  final Function onLoadMore;

  SmartRefreshListView(
      {@required this.datas,
      @required this.emptyViewStatus,
      @required this.renderList,
      this.onrefresh,
      this.onLoadMore})
      : assert(datas != null),
        assert(emptyViewStatus != null),
        assert(renderList != null);
  @override
  createState() => _SmartRefreshListViewState();
}

class _SmartRefreshListViewState extends State<SmartRefreshListView> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new EmptyView(
        status: widget.emptyViewStatus,
        child: new Container(
            color: Theme.of(context).backgroundColor,
            child: new RefreshIndicator(
                child: new ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.datas.length + 1,
                  itemBuilder: (context, index) => widget.renderList(index),
                ),
                onRefresh: widget.onrefresh)));
  }
}
