import 'package:flutter/material.dart';
import './empty_view.dart';
import '../model/empty_view_status.dart';
import '../constant/strings.dart';

/// 缺省、下拉刷新、上拉加载封装
class SmartListView extends StatefulWidget {
  /// 数据列表
  final List<Object> datas;

  /// 背景色
  final Color backgroundColor;

  /// 缺省View状态
  final EmptyViewStatus emptyViewStatus;

  // 缺省View文案显示
  final String emptyViewRemark;

  /// 是否启用下拉刷新
  final bool refreshEnable;

  /// 是否启用加载更多
  final bool loadMoreEnable;

  /// 渲染回调
  final Function(int) renderList;

  /// 刷新回调
  final Future<void> Function() onrefresh;

  /// 加载更多回调
  final Function onLoadMore;

  SmartListView({
    @required this.datas,
    @required this.emptyViewStatus,
    @required this.renderList,
    this.emptyViewRemark = StringValues.EMPTY_NO_DATA_REMARK,
    this.backgroundColor,
    this.refreshEnable = true,
    this.loadMoreEnable = true,
    this.onrefresh,
    this.onLoadMore,
  })  : assert(datas != null),
        assert(emptyViewStatus != null),
        assert(renderList != null);
  @override
  createState() => _SmartListViewState();
}

class _SmartListViewState extends State<SmartListView> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _scrollController = new ScrollController();

    if (widget.loadMoreEnable) {
      // 启用加载更多,设置监听
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          widget.onLoadMore();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new EmptyView(
        status: widget.emptyViewStatus,
        remark: widget.emptyViewRemark,
        child: new Container(
            color: widget.backgroundColor ?? Theme.of(context).backgroundColor,
            child: new RefreshIndicator(
                child: new ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.loadMoreEnable
                      ? widget.datas.length + 1
                      : widget.datas.length,
                  itemBuilder: (context, index) => widget.renderList(index),
                ),
                onRefresh: () async =>
                    widget.refreshEnable ? widget.onrefresh() : null)));
  }
}
