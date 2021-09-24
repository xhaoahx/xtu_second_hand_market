import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';

import 'package:xtusecondhandmarket/ui/page/goods_details_page/goods_details_page.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';

import '../../../logic/model/global_goods_model.dart';
import '../../../logic/model/theme_model.dart';

const Color _tag1Color = Color(0xFF03D654);
const Color _tag2Color = Color(0xFFFED269);
const double _clipRadius = 14.0;

class GoodsCard extends StatelessWidget {
  const GoodsCard(
    this.shortDetails,
  ) : assert(shortDetails != null);

  final ShortGoodsDetails shortDetails;

  @override
  Widget build(BuildContext context) {
    Widget result = _GoodsCard(shortDetails);
//    if (shortDetails.isFirstBuild) {
//      result = _FirstBuildWrapper(result);
//      shortDetails.isFirstBuild = false;
//    }
    return result;
  }
}

class _FirstBuildWrapper extends StatefulWidget {
  const _FirstBuildWrapper(this.goodsCard);
  final _GoodsCard goodsCard;

  @override
  _FirstBuildWrapperState createState() => _FirstBuildWrapperState();
}

class _FirstBuildWrapperState extends State<_FirstBuildWrapper>
    with SingleTickerProviderStateMixin<_FirstBuildWrapper> {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  static final math.Random _random = math.Random.secure();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _random.nextInt(300) + 300,
      ),
    );
    _offsetAnimation = Tween(
      begin: Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      curve: Curves.decelerate,
      parent: _controller,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.goodsCard,
    );
  }
}

class _GoodsCard extends StatelessWidget {
  const _GoodsCard(
    this.details,
  ) : assert(details != null);

  final ShortGoodsDetails details;

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;

    final Widget imageWidget = CachedNetworkImage(
      imageUrl: details.imgUrl,
      imageBuilder: (context, image) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_clipRadius),
            topRight: Radius.circular(_clipRadius),
          ),
          child: SizedBox.expand(
            child: Image(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => const SizedBox(
        child: Center(
          child: Text('加载失败'),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final Widget titleWidget = Text(
      details.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: fontData.h4_4,
      textAlign: TextAlign.start,
    );

    final Widget priceWidget = RichText(
      text: TextSpan(children: [
        TextSpan(
          text: details.newPrice,
          style: fontData.h5_4.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
        TextSpan(
          text: '￥',
          style: fontData.h5_4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ]),
    );

    final Widget tag1 =
        _buildTag(purchaseWayToString(details.purchaseWay), _tag1Color);
    final Widget tag2 =
        _buildTag(isNewToString(details.isNew), _tag2Color);

    final Widget tags = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        tag1,
        const SizedBox(
          width: 2.0,
        ),
        tag2,
      ],
    );

    final Widget infoWidget = Padding(
      padding: const EdgeInsets.only(
        top: 2.0,
        right: 5.0,
        left: 5.0,
        bottom: 5.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleWidget,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              priceWidget,
              Expanded(
                child: tags,
              )
            ],
          )
        ],
      ),
    );

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_clipRadius),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.4,
            offset: Offset(0.0, 1.6),
            color: Colors.black12,
          ),
        ],
      ),
      //margin: const EdgeInsets.all(2.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: imageWidget,
          ),
          infoWidget,
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        _handleOnTap(context);
      },
      child: card,
    );
  }

  void _handleOnTap(BuildContext context) {
    final bool isLogin = GlobalUserModel.of(context).isUserLogin;
    if (isLogin) {
      Navigator.of(context).pushNamed(
        GoodsDetailsPage.routeName,
        arguments: details,
      );
    } else {
      Navigator.of(context).pushNamed(
        LoginPage.routeName,
        arguments: LoginPageArguments(
          nextPageArguments: details,
          nextPageRouteName: GoodsDetailsPage.routeName,
        ),
      );
    }
  }

  Widget _buildTag(String text, Color color) {
    return text == null ? _GoodsTag.empty : _GoodsTag(color, text);
  }
}

class _GoodsTag extends StatelessWidget {
  const _GoodsTag(
    this.bgColor,
    this.text,
  );

  final Color bgColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 1.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99999.0),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: FontData.baseTextStyle.copyWith(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }

  static const empty = _GoodsTag(Colors.transparent, '');
}
