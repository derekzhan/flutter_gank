import 'package:flutter/material.dart';
import '../model/category_info.dart';
import '../page/gank_item_page.dart';

/// 分类页面
class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _tabController = TabController(vsync: this, length: categorys.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Tab _buildTab(CategoryInfo category) =>
      new Tab(text: category.name == 'all' ? '全部' : category.name);

  Widget _buildPage(CategoryInfo category) => new GankItemPage(category.name);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget tabBar = new Material(
        elevation: 4.0,
        child: new TabBar(
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Theme.of(context).primaryColor,
            labelColor: Colors.grey[800],
            /// 指示器
            indicatorSize: TabBarIndicatorSize.label,
            tabs: categorys.map(_buildTab).toList()));

    final Widget body = new Container(
        margin: const EdgeInsets.only(top: kTextTabBarHeight),
        child: new TabBarView(
            controller: _tabController,
            children: categorys.map(_buildPage).toList()));

    return new DefaultTabController(
        length: categorys.length,
        child: new Stack(children: <Widget>[body, tabBar]));
  }

  @override
  bool get wantKeepAlive => true;
}
