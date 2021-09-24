import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import 'goods_details_page.dart' show kTransDuration, kInfoHeight;

const String _kLoadingText = '加载中...';

class GoodsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget result = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        final FontData fontData = ThemeModel.of(context).fontData;
        final FullGoodsDetails details = DetailsPageModel.of(context).fullDetails;

        final Widget oldPrice = Text(
          isLoading ? _kLoadingText : '￥${details.oldPrice}',
          style: fontData.h4_1.copyWith(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        );

        final Widget newPrice = Text(
          isLoading ? _kLoadingText : '￥${details.newPrice}',
          style: fontData.h3_1.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        );

        final Widget pastDays = Text(
          isLoading ? _kLoadingText : _calculatePastDay(details.publishDate),
          style: fontData.h5_1.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        );

        final Widget title = Text(
          isLoading ? _kLoadingText : details.title,
          style: fontData.h3_1,
        );

        Widget result = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      newPrice,
                      const SizedBox(width: 5.0,),
                      oldPrice,
                    ],
                  ),
                ),
                pastDays,
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: title,
            ),
          ],
        );

        return AnimatedOpacity(
          opacity: isLoading ? 0.0 : 1.0,
          child: result,
          duration: kTransDuration,
        );
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      height: kInfoHeight,
      alignment: Alignment.bottomLeft,
      child: result,
    );
  }

  String _calculatePastDay(String publishDate) {
    final DateTime dateTime = DateTime.tryParse(publishDate) ?? DateTime.now();
    final int pastDay = dateTime.difference(DateTime.now()).inDays;
    return '这个宝贝已经发布$pastDay天，赶快带走它吧~';
  }
}
