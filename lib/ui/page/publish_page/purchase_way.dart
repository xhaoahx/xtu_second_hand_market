import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/common/contact.dart';
import 'package:xtusecondhandmarket/logic/common/goods.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../widget/special/basic_chip_button.dart';

class PurchaseWay extends StatelessWidget {
  const PurchaseWay();

  @override
  Widget build(BuildContext context) {
    final Widget leading = SizedBox(
      width: 100.0,
      height: kLineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 24.0,
            child: Image.asset(
              'assets/img/publish_page/方式@hdpi.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '交易方式',
                style: ThemeModel.of(context).fontData.h4_4.copyWith(
                      fontSize: kTextFontSize,
                      color: Colors.grey,
                    ),
              ),
            ),
          )
        ],
      ),
    );

    final Widget buttons = SizedBox(
      height: kLineHeight,
      child: Row(
        children: <Widget>[
          _PurchaseWayButton(0),
          const SizedBox(width: 15.0),
          _PurchaseWayButton(1),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: buttons,
        ),
      ],
    );
  }
}

class _PurchaseWayButton extends StatelessWidget {
  const _PurchaseWayButton(this.purchaseWay);

  final int purchaseWay;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: purchaseWayToString(purchaseWay),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.purchaseWayIndex == purchaseWay;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.handlePurchaseWayChange(purchaseWay);
  }
}
