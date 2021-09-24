import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/contact.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import 'goods_details_page.dart' show kTransDuration, kHeaderHeight;

const String _loadingPublisher = '加载中........';
const String _loadingGrade = '学历';
const String _loadingDormitory = '位置';
const String _loadingVerify = '认证';

const Color buttonColor = Color(0xFFFFF3CA);

const List<String> _iconPaths = [
  'assets/img/goods_details_page/学历@hdpi.png',
  'assets/img/goods_details_page/地址@hdpi.png',
  'assets/img/goods_details_page/授权@hdpi.png'
];

class DetailsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget result = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        final DetailsPageModel model = DetailsPageModel.of(context);
        final FullGoodsDetails details = model.fullDetails;
        final FontData fontData = ThemeModel.of(context).fontData;

        final Widget name = AnimatedSwitcher(
          duration: kTransDuration,
          child: Text(
            isLoading ? _loadingPublisher : model.publisher.name,
            key: ValueKey<bool>(isLoading),
            style: fontData.h4_4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        );

        final Widget contactButton = _ContactButton(isLoading);

        final Widget avatar = isLoading
            ? const SizedBox()
            : CachedNetworkImage(
                imageUrl: model.publisher.avatarUrl,
                imageBuilder: (
                  BuildContext context,
                  ImageProvider imageProvide,
                ) {
                  return Container(
                    width: kHeaderHeight * 0.8,
                    height: kHeaderHeight * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvide, fit: BoxFit.cover),
                    ),
                  );
                },
              );

        final Widget line1 = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96.0,
              alignment: Alignment.centerLeft,
              child: name,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: contactButton,
            ),
          ],
        );

        final Widget line2 = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTag(
              context,
              gradeToString(details?.grade),
              _loadingGrade,
              _iconPaths[0],
              isLoading,
            ),
            _buildTag(
              context,
              dormitoryToString(details?.dormitory),
              _loadingDormitory,
              _iconPaths[1],
              isLoading,
            ),
            _buildTag(
              context,
              '已认证',
              _loadingVerify,
              _iconPaths[2],
              isLoading,
            ),
            const SizedBox(
              width: 30.0,
            )
          ],
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  line1,
                  line2,
                ],
              ),
            ),
            avatar,
          ],
        );
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    return SizedBox(
      height: kHeaderHeight,
      child: Container(
        child: result,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildTag(
    BuildContext context,
    String title,
    String placeHolder,
    String iconPath,
    bool isLoading,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 16.0,
          width: 16.0,
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
        AnimatedSwitcher(
          child: Text(
            isLoading ? placeHolder : title,
            key: ValueKey<bool>(isLoading),
            maxLines: 1,
            style: ThemeModel.of(context).fontData.h5_1,
          ),
          duration: kTransDuration,
        ),
        const SizedBox(
          width: 30.0,
        ),
      ],
    );
  }
}

class _ContactButton extends StatefulWidget {
  _ContactButton(this.isLoading);

  final bool isLoading;
  @override
  _ContactButtonState createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _shouldShow = false;

  @override
  Widget build(BuildContext context) {
    final bool shouldShow = _shouldShow && !widget.isLoading;

    final Widget button = FlatButton(
      color: buttonColor,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      splashColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      child: AnimatedSwitcher(
        child: Text(
          shouldShow ? _getOnlineWay(context) : '显示线上联系方式',
          key: ValueKey<bool>(shouldShow),
          maxLines: 1,
          style: ThemeModel.of(context).fontData.h5_1.copyWith(
                color: Color(0xFFFFF7911),
              ),
        ),
        duration: kTransDuration,
      ),
      onPressed: _handleTap,
    );

    return SizedBox(
      height: 26.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: button,
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _shouldShow = true;
    });
  }

  String _getOnlineWay(BuildContext context) {
    final DetailsPageModel model = DetailsPageModel.of(context);
    if (model.isLoadingPage) {
      return null;
    }
    final FullGoodsDetails details = model.fullDetails;
    return '${onlineWayToString(details.onlineWay)}:${details.onlineNum}';
  }
}
