import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import 'goods_details_page.dart' show kTransDuration;

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget description = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        return AnimatedSwitcher(
          child: isLoading ? const Text('加载中...') : _buildDescription(context),
          duration: kTransDuration,
        );
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: description,
    );
  }

  Widget _buildDescription(BuildContext context) {
    final FullGoodsDetails details = DetailsPageModel.of(context).fullDetails;
    final FontData fontData = ThemeModel.of(context).fontData;

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(children: <InlineSpan>[
        WidgetSpan(
          child: Container(
            alignment: Alignment.center,
            width: 42.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.lightGreen,
            ),
            child: Text(
              purchaseWayToString(details.purchaseWay),
              style: fontData.h5_2.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        TextSpan(
          text: details.description,
          style: fontData.h5_2,
        )
      ]),
    );
  }
}
