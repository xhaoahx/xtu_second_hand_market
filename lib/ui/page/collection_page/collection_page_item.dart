import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/logic/model/collection_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/goods_details_page/goods_details_page.dart';

import 'package:xtusecondhandmarket/ui/widget/common/animated_list_wrapper.dart';

const String _typeKey = 'collection_page_sliver';

class CollectionPageItem extends StatelessWidget {
  CollectionPageItem({Key key, this.details}) : super(key: key);

  final FullGoodsDetails details;

  static final Tween<Offset> _positionTween = Tween(
    begin: Offset(-1.0, 0.0),
    end: Offset.zero,
  );

  static final Tween<double> _sizeTween = Tween(
    begin: 0.0,
    end: 1.0,
  );

  static const Duration _kTransDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return AnimatedSliverWrapper(
      builder: (BuildContext context) => _CollectionPageItem(details),
      forwardDuration: _kTransDuration,
      typeKey: _typeKey,
      factor: 0.3,
      enable: details.isFirstBuild,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget child,
      ) {
        return SlideTransition(
          position: _positionTween.animate(animation),
          child: child,
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget child,
      ) {
        print('build reverse');

        final Animation<double> slideAnimation =
            CurvedAnimation(curve: Interval(0.4, 1.0), parent: animation);

        final Animation<double> sizeAnimation =
            CurvedAnimation(curve: Interval(0.0, 0.4), parent: animation);

        return SlideTransition(
          position: _positionTween.animate(slideAnimation),
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _sizeTween.animate(sizeAnimation),
            child: child,
          ),
        );
      },
    );
  }
}

const double _kItemHeight = 160.0;
const double _kImgHeight = 100.0;
const double _kBorderRadius = 20.0;

class _CollectionPageItem extends StatelessWidget {
  const _CollectionPageItem(this.details);

  final FullGoodsDetails details;

  @override
  Widget build(BuildContext context) {
    details.isFirstBuild = false;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          GoodsDetailsPage.routeName,
          arguments: details,
        );
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;

    final double topHeight = _kItemHeight * 0.18;

    final Widget top = Container(
      height: topHeight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(_kBorderRadius),
            topLeft: Radius.circular(_kBorderRadius),
          ),
          color: Theme.of(context).primaryColor),
      child: PopupMenuButton<bool>(
        tooltip: null,
        padding: const EdgeInsets.only(right: 16.0),
        icon: Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        color: Colors.black38,
        offset: Offset(0.0,topHeight),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<bool>>[
            PopupMenuItem<bool>(
              value: true,
              child: Center(
                child: Text(
                  '取消收藏',
                  style: fontData.h5_1.copyWith(color: Colors.white),
                ),
              )
            )
          ];
        },
        onSelected: (bool value) {
          if (value) {
            _handlePress(context);
          }
        },
      ),
      alignment: Alignment.centerRight,
    );

    final Widget img = SizedBox(
      width: _kImgHeight,
      height: _kImgHeight,
      child: CachedNetworkImage(
        imageUrl: details.imgUrls[0],
        fit: BoxFit.cover,
      ),
    );

    final Widget title = Text(
      details.title,
      maxLines: 1,
      style: fontData.h4_4,
    );

    final Widget description = Text(
      details.description,
      maxLines: 2,
      style: fontData.h5_2,
    );

    final Widget info = RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${details.newPrice} ',
            style: fontData.h4_1
                .copyWith(fontWeight: FontWeight.w600, color: Colors.red),
          ),
          TextSpan(
            text: details.oldPrice,
            style:
                fontData.h5_2.copyWith(decoration: TextDecoration.lineThrough),
          ),
          const TextSpan(text: ' '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              width: 10.0,
              height: 10.0,
              child: Image.asset(
                'assets/img/collection_page/时间@hdpi.png',
              ),
            ),
          ),
          TextSpan(text: details.publishDate, style: fontData.h5_2),
        ],
      ),
    );

    final Widget content = Row(
      children: <Widget>[
        img,
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              title,
              description,
              info,
            ],
          ),
        )
      ],
    );

    return Container(
      height: _kItemHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kBorderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6.0,
            offset: Offset(0.0, 4.0),
          )
        ],
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          top,
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePress(BuildContext context) async {
    final CollectionPageModel model = CollectionPageModel.of(context);
    await AnimatedSliverWrapper.of(context).reverse();
    model.handleCancelLike(details);
  }
}
