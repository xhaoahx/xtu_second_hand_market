import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/collection_page/collection_page.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';
import 'package:xtusecondhandmarket/ui/page/navigation/navigation.dart';


import '../../../ui/widget/common/decorated_text.dart';

class ItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = constraints.biggest;
        final double height = size.height;
        final double width = size.width;

        final FontData fontData = ThemeModel.of(context).fontData;

        final Widget description = Align(
          alignment: Alignment.centerLeft,
          child: DecoratedText(
            TextSpan(
              text: '我的主页',
              style: fontData.h3_1.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        );

        final Widget aboutUs = Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height * 0.0275),
                bottomLeft: Radius.circular(height * 0.0275),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  child: Image.asset('assets/img/profile_page/问号@hdpi.png'),
                  padding: const EdgeInsets.all(3.0),
                ),
                Text(
                  '关于我们',
                  style: fontData.h4_1,
                ),
                SizedBox(
                  width: 3.0,
                )
              ],
            ),
          ),
        );

        final Widget items = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _sectionInfoList.map<Widget>((_SectionInfo sectionInfo) {
            final double imgSize = height * 0.0879;
            return _SectionWidget(
              imgSize: imgSize,
              sectionInfo: sectionInfo,
            );
          }).toList(),
        );

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              child: description,
              left: width * 0.05,
              top: 15.0,
              right: 0.0,
              height: 80.0,
            ),
            Positioned(
              right: 0.0,
              left: 0.0,
              top: 0.176 * height,
              height: 0.045 * height,
              child: aboutUs,
            ),
            Positioned(
              top: height * 0.204,
              bottom: height * 0.157,
              left: width * 0.05,
              right: width * 0.05,
              child: items,
            ),
          ],
        );
      },
    );
  }
}

class _SectionInfo {
  const _SectionInfo({
    this.title,
    this.iconPath,
    this.description,
    this.routeName,
  });
  final String iconPath;
  final String description;
  final String title;
  final String routeName;
}

const List<_SectionInfo> _sectionInfoList = [
  _SectionInfo(
    iconPath: 'assets/img/profile_page/发布@hdpi.png',
    description: '快去发布宝贝吧！',
    title: '我发布的',
    routeName: 'my_publish_page',
  ),
  _SectionInfo(
    iconPath: 'assets/img/profile_page/卖出@hdpi.png',
    description: '卖出的宝贝在这里~',
    title: '我卖出的',
    routeName: 'my_sell_out_page',
  ),
  _SectionInfo(
    iconPath: 'assets/img/profile_page/收藏@hdpi.png',
    description: '收藏的宝贝多来看看~',
    title: '我的收藏',
    routeName: CollectionPage.routeName,
  ),
  _SectionInfo(
    iconPath: 'assets/img/profile_page/留言@hdpi.png',
    description: '有人找你喔！',
    title: '我的消息',
    routeName: 'my_message_page',
  ),
];

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({this.imgSize, this.sectionInfo});

  final _SectionInfo sectionInfo;
  final double imgSize;

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;

    final Widget result = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: imgSize,
          width: imgSize,
          child: Image.asset(sectionInfo.iconPath),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            sectionInfo.description,
            style: fontData.h4_3.copyWith(
              fontSize: 14.0
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(
          width: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                sectionInfo.title,
                style: fontData.h4_4.copyWith(
                  fontSize: 14.0
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(Icons.chevron_right)
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        _onTap(context);
      },
      child: result,
    );
  }

  void _onTap(BuildContext context) {
    final GlobalUserModel userModel = GlobalUserModel.of(context);
    if(userModel.isUserLogin){
      Navigator.of(context).pushNamed(sectionInfo.routeName);
    }else{
      Navigator.of(context).pushNamed(LoginPage.routeName);
    }
  }
}
