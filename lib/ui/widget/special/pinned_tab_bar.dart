import 'package:flutter/material.dart';

import '../../../logic/model/theme_model.dart';

const Duration _kTranslateDuration = Duration(milliseconds: 300);
const double _kIndicatorWidth = 20.0;
const double _kTabBarHeight = 60.0;
const Object _indicatorId = Object();

class PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  const PinnedTabBarDelegate({
    this.factor,
    this.titles,
  })  : assert(factor != null),
        assert(factor != null && factor > 0.0);

  final List<String> titles;
  final double factor;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
      child: _PinnedTabBar(
        titles: titles,
        factor: factor,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withAlpha(60),
            width: 0.5,
          )
        )
      ),
    );
  }

  @override
  double get maxExtent => _kTabBarHeight;

  @override
  double get minExtent => _kTabBarHeight;

  @override
  bool shouldRebuild(PinnedTabBarDelegate oldDelegate) => false;
}

class _PinnedTabBar extends StatelessWidget {
  const _PinnedTabBar({
    this.factor,
    this.titles,
  });

  final List<String> titles;
  final double factor;

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * factor,
      height: _kTabBarHeight,
      child: CustomMultiChildLayout(
        children: <Widget>[
          ..._buildTabs(controller),
          _buildIndicator(),
        ],
        delegate: _PinnedTabBarLayoutDelegate(
            tabController: controller, titles: titles),
      ),
    );
  }

  List<Widget> _buildTabs(TabController controller) {
    return List<Widget>.generate(titles.length, (index) {
      final Widget tab = GestureDetector(
          onTap: () {
            controller.animateTo(index);
          },
          child: SizedBox(
              child: Center(
                child: _TabTitle(
                  title: titles[index],
                  index: index,
                  tabController: controller,
                ),
              )
          )
      );

      return LayoutId(
        id: titles[index],
        child: tab
      );
    });
  }

  Widget _buildIndicator() {
    return LayoutId(
      child: SizedBox(
        width: _kIndicatorWidth,
        height: _kIndicatorWidth,
        child: Image.asset('assets/img/market_page/滑块栏@xhdpi.png'),
      ),
      id: _indicatorId,
    );
  }

}

class _TabTitle extends StatefulWidget {
  const _TabTitle({
    this.index,
    this.tabController,
    this.title,
  });

  final String title;
  final int index;
  final TabController tabController;

  @override
  _TabTitleState createState() => _TabTitleState();
}

class _TabTitleState extends State<_TabTitle> {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.tabController;
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (_controller.previousIndex != _controller.index) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;

    return AnimatedDefaultTextStyle(
      duration: _kTranslateDuration,
      curve: Curves.linear,
      style: _controller.index == widget.index
          ? fontData.h4_4.copyWith(fontWeight: FontWeight.w700)
          : fontData.h5_2,
      textAlign: TextAlign.center,
      child: Text(widget.title),
    );
  }
}

class _PinnedTabBarLayoutDelegate extends MultiChildLayoutDelegate {
  _PinnedTabBarLayoutDelegate({
    this.titles,
    this.tabController,
  }) : super(relayout: tabController.animation);

  final TabController tabController;
  final List<String> titles;

  @override
  void performLayout(Size size) {
    final double hWidth = size.width / titles.length;
    final double bWidth = hWidth * 0.5;
    final double height = size.height;

    final BoxConstraints constraints = BoxConstraints.tight(
      Size(
        hWidth,
        height - _kIndicatorWidth,
      ),
    );

    for (int i = 0; i < titles.length; ++i) {
      final String title = titles[i];

      final Size layoutSize = layoutChild(title, constraints);

      positionChild(
        title,
        Offset(
           i * hWidth,
          (height - layoutSize.height) * 0.5,
        ),
      );
    }

    layoutChild(
      _indicatorId,
      BoxConstraints.tight(
        Size(
          _kIndicatorWidth,
          _kIndicatorWidth,
        ),
      ),
    );

    positionChild(
      _indicatorId,
      Offset(
        bWidth * (2 * tabController.animation.value + 1) -
            _kIndicatorWidth * 0.5,
        height - _kIndicatorWidth,
      ),
    );
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
