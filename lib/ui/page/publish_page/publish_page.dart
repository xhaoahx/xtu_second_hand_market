import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/button.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/dormitory_info.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/grade_info.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/online_info.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/phone_num.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/picture.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/purchase_way.dart';
import 'package:xtusecondhandmarket/ui/page/publish_page/type_info.dart';
import 'package:xtusecondhandmarket/ui/widget/common/decorated_text.dart';

import 'goods_title.dart';
import 'description.dart';
import 'classification.dart';
import 'price.dart';

import '../../../logic/model/theme_model.dart';
import '../../../logic/model/publish_page_model.dart';


const EdgeInsetsGeometry _kPadding1 = EdgeInsets.symmetric(
  horizontal: 18.0,
  vertical: 0.0,
);

const EdgeInsetsGeometry _kPadding2 = EdgeInsets.symmetric(
  horizontal: 18.0,
  vertical: 14.0,
);

class PublishPage extends StatefulWidget {
  const PublishPage();

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> with AutomaticKeepAliveClientMixin<PublishPage>{
  PublishPageContent _content;
  OverlayEntry _contentOverlay;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _content = PublishPageContent();
    _contentOverlay = OverlayEntry(
      builder: (context) => _content,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Widget appBar = Container(
      color: Theme.of(context).primaryColor,
      height: 86.0,
      alignment: Alignment.center,
      child: SafeArea(
        child: Text(
          '发布宝贝',
          style: ThemeModel.of(context).fontData.h3_2,
        ),
      ),
    );

    return Column(
      children: <Widget>[
        appBar,
        Expanded(
          child: ClipRRect(
            child: Overlay(
              initialEntries: <OverlayEntry>[_contentOverlay],
            ),
          )
        )
      ],
    );
  }
}

class PublishPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('publishPageContenet rebuild');
    
    final FontData fontData = ThemeModel.of(context).fontData;
    final PublishPageModel publishPageModel = PublishPageModel.of(context);

    final Widget title = const GoodsTitle();

    final Widget description = const Description();

    final Widget picture = const Picture();

    final Widget contactTitle = DecoratedText(
      TextSpan(
        text: '联系信息',
        style: fontData.h4_4.copyWith(fontWeight: FontWeight.w700),
      ),
    );

    final Widget gradeInfo = const GradeInfo();

    final Widget dormitoryInfo = const DormitoryInfo();

    final Widget phoneNum = const PhoneNum();

    final Widget classification = const Classification();

    final Widget type = const TypeInfo();

    final Widget purchaseWay = const PurchaseWay();

    final Widget price = const Price();

    final Widget onlineWay = const OnlineInfo();

    final Widget onlineNum = const OnlineTextFields();

    final Widget goodsTitle = DecoratedText(
      TextSpan(
        text: '商品信息',
        style: fontData.h4_4.copyWith(fontWeight: FontWeight.w700),
      ),
    );

    final Widget publishButton = const PublishButton();

    final Widget pageList = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      controller: publishPageModel.pageManager.pageController,

      /// Note: We use column here to make sure context is reused
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Description
          Padding(padding: _kPadding1, child: title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(),
          ),
          Padding(padding: _kPadding1, child: description),
          picture,

          /// Contact Info
          const SizedBox(height: 10.0),
          Padding(padding: _kPadding1, child: contactTitle),
          const SizedBox(height: 10.0),
          Padding(padding: _kPadding2, child: gradeInfo),
          Padding(padding: _kPadding2, child: dormitoryInfo),
          Padding(padding: _kPadding2, child: phoneNum),
          Padding(padding: _kPadding2, child: onlineWay),
          Padding(padding: _kPadding2, child: onlineNum),

          /// Goods Info
          Padding(padding: _kPadding1, child: goodsTitle),
          const SizedBox(height: 10.0),
          Padding(padding: _kPadding2, child: price),
          Padding(padding: _kPadding2, child: classification),
          Padding(padding: _kPadding2, child: type),
          Padding(padding: _kPadding2, child: purchaseWay),
          const SizedBox(height: 16.0),
          Padding(padding: _kPadding1, child: publishButton),
        ],
      ),
    );

    return pageList;
  }
}

