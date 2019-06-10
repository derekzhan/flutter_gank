import 'package:flutter/material.dart';
import '../widget/placeholder_image_view.dart';
import '../util/display_util.dart';
import '../page/photo_gallery_page.dart';

/// 妹子列表项 widget
class MeiZiListItem extends StatelessWidget {
  final String url;
  final int currentIndex;

  MeiZiListItem(this.url, {Key key, @required this.currentIndex})
      : super(key: key);

  void _onPhotoTap(BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => new PhotoGalleryPage([url])));

  @override
  Widget build(BuildContext context) {
    double itemHeight = 500.0;
    double spacing = 8.0;
    double topSpacing = currentIndex == 0 ? spacing : 0.0;

    return new Container(
        height: itemHeight,
        margin: new EdgeInsets.only(
            top: topSpacing, bottom: spacing, left: spacing, right: spacing),
        child: new Hero(
            // 动画
            tag: this.url,
            // 卡片
            child: new Card(
                margin: const EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: new Stack(children: <Widget>[
                  new PlaceholderImageView(this.url,
                      width: DisPlayUtil.getScreenWidth(context),
                      height: itemHeight,
                      fit: BoxFit.cover),
                  new Material(
                      type: MaterialType.transparency,
                      // InkWell 墨水池 水波纹效果
                      child: new InkWell(onTap: () => _onPhotoTap(context)))
                ]))));
  }
}
