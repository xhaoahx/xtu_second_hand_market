import 'package:flutter/material.dart';

import '../../../logic/model/theme_model.dart';

import 'market_page.dart';

class MarketPageAppBar extends StatelessWidget {

  const MarketPageAppBar({
    this.marketPageState,
    this.scrollController,
  });

  final ScrollController scrollController;
  final MarketPageState marketPageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: SafeArea(
        child: _AppbarTitle(
          listState: marketPageState,
          scrollController: scrollController,
        ),
      )
    );
  }
}


class _AppbarTitle extends StatefulWidget {
  const _AppbarTitle({
    this.scrollController,
    this.listState,
  });

  final ScrollController scrollController;
  final MarketPageState listState;
  @override
  __AppbarTitleState createState() => __AppbarTitleState();
}

class __AppbarTitleState extends State<_AppbarTitle> {
  ScrollController _controller;
  bool _shouldShow = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController;
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    final ScrollPosition position = _controller.position;

    /// out of range,show
    if (position.pixels > 0 && position.atEdge && !_shouldShow) {
      setState(() {
        _shouldShow = true;
      });
    }

    /// entry range,don't show
    else if (position.pixels < 100.0 && _shouldShow) {
      setState(() {
        _shouldShow = false;
      });
    }
  }

  void _onTap() {
    if (_shouldShow) {
      widget.listState.animateToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;

    return GestureDetector(
      child: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            child: child,
            opacity: animation,
          );
        },
        child: Text(
          _shouldShow ? '回到顶部' : '湘大二手街',
          key: ValueKey(_shouldShow),
          style: fontData.h3_1,
        ),
        duration: const Duration(milliseconds: 300),
      ),
      onTap: _onTap,
    );
  }
}
