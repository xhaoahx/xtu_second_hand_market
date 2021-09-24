import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../logic/model/theme_model.dart';
import '../../widget/special/tab_icon.dart';

const _kIconSize = 24.0;
const int _kInitIndex = 0;
const Duration _kTranslateDuration = Duration(milliseconds: 400);
const double _kTabBarHeight = 54.0;
const List<String> _titles = [
  '二手街',
  '发布',
  '我的',
];

class NavigationTabBar extends StatelessWidget {
  const NavigationTabBar(this.pageController);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 6.0,
        bottom: 4.0
      ),
      height: _kTabBarHeight,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(_titles.length, (index) {
          return TabWidget(
            index: index,
            pageController: pageController,
            onTap: () {
              pageController.jumpToPage(index);
            },
          );
        }),
      ),
    );
  }
}

class TabWidget extends StatefulWidget {
  TabWidget({
    this.index,
    this.pageController,
    this.onTap,
  });

  final int index;
  final PageController pageController;
  final VoidCallback onTap;

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin<TabWidget> {
  PageController _pageController;
  int _index;
  AnimationController _controller;
  bool _previousIsSelected;

  @override
  void initState() {
    super.initState();
    _ensureFields();
    final initIsSelected = _isSelected;
    _controller = AnimationController(
      vsync: this,
      duration: _kTranslateDuration,
      value: initIsSelected ? 1.0 : 0.0,
    );
    _previousIsSelected = initIsSelected;
  }

  @override
  void didUpdateWidget(TabWidget oldWidget) {
    oldWidget.pageController?.removeListener(_listener);
    _ensureFields();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _listener() {
    final isSelected = _isSelected;
    if (mounted && _previousIsSelected != isSelected) {
      if (_previousIsSelected && !isSelected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _previousIsSelected = isSelected;
    }
  }

  void _ensureFields() {
    _pageController = widget.pageController;
    _pageController.addListener(_listener);
    _index = widget.index;
  }

  bool get _isSelected {
    final double page = _pageController.page;
    if (page == null) {
      return _index == _kInitIndex;
    } else {
      return page.toInt() == _index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final ThemeData themeData = Theme.of(context);

    final TextStyleTween styleTween = TextStyleTween(
      begin: fontData.h5_2,
      end: fontData.h5_2.copyWith(color: themeData.primaryColor),
    );

    final Widget title = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Text(
          _titles[widget.index],
          textAlign: TextAlign.center,
          style: styleTween.evaluate(_controller),
        );
      },
    );

    final Widget icon = SizedBox(
      height: _kIconSize,
      width: _kIconSize,
      child: CustomPaint(
        painter: _buildIcon(context, _controller, widget.index),
        size: Size(_kIconSize, _kIconSize),
      ),
    );

    return MaterialButton(
      onPressed: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          icon,
          title,
        ],
      ),
    );
  }

  static CustomPainter _buildIcon(
      BuildContext context, AnimationController controller, int index) {
    final Color mainColor = Theme.of(context).primaryColor;
    const Color bgColor = Color(0xFF707070);
    switch (index) {
      case 0:
        return MarketIcon(
            bgColor: bgColor, mainColor: mainColor, animation: controller);
      case 1:
        return PublishIcon(
            bgColor: bgColor, mainColor: mainColor, animation: controller);
      case 2:
        return ProfileIcon(
            bgColor: bgColor, mainColor: mainColor, animation: controller);
      default:
        throw Exception('unknow type of icon');
    }
  }
}
