import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/ui/page/collection_page/collection_page.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';

import 'app_bar.dart';
import 'header.dart';
import 'classification.dart';
import 'goods_list.dart';
import '../../widget/special/pinned_tab_bar.dart';
import '../../widget/common/enhanced_nsv.dart';
import '../../../logic/model/global_goods_model.dart';

/// we expect scroll 1.2 px / ms
const double _kBackToTopVelocity = 1.0;
const int _kBackToTopMaxDuration = 500;

const double _kFloatButtonSize = 48.0;
const double _kAppBarHeight = 86.0;

class MarketPage extends StatefulWidget {
  const MarketPage();

  @override
  MarketPageState createState() => MarketPageState();

  static MarketPageState of(BuildContext context) {
    return context.findAncestorStateOfType<MarketPageState>();
  }
}

class MarketPageState extends State<MarketPage>
    with AutomaticKeepAliveClientMixin<MarketPage> {
  final GlobalKey<EnhancedNestedScrollViewState> _goodListKey = GlobalKey();
  ScrollController _outerController;

  @override
  void initState() {
    super.initState();
    _outerController = ScrollController();
    _firstTimeLoading();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _outerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Widget appBar = MarketPageAppBar(
      scrollController: _outerController,
      marketPageState: this,
    );

    final Widget listBody = DefaultTabController(
      child: EnhancedNestedScrollView(
        key: _goodListKey,
        controller: _outerController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            Header(),
            SliverPadding(
              sliver: Classification(),
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
            ),
            SliverOverlapAbsorber(
              handle: EnhancedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverPersistentHeader(
                delegate: PinnedTabBarDelegate(
                  factor: 0.4,
                  titles: List<String>.generate(
                    listTypeCount,
                    (index) => listTypeToString(index),
                  ),
                ),
                pinned: true,
              ),
            ),
          ];
        },
        body: _buildTabBarView(),
      ),
      length: listTypeCount,
    );

    final Widget floatButton = DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/market_page/首页小@hdpi.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: FlatButton(
        padding: const EdgeInsets.all(1.0),
        shape: CircleBorder(),
        child: const SizedBox(),
        onPressed: _onFloatButtonTap,
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned(
          child: appBar,
          left: 0.0,
          right: 0.0,
          height: _kAppBarHeight,
        ),
        Positioned(
          top: _kAppBarHeight,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: listBody,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6,
          right: 25.0,
          width: _kFloatButtonSize,
          height: _kFloatButtonSize,
          child: floatButton,
        )
      ],
    );  
  }

  Future<void> animateToTop() async {
    final EnhancedNestedScrollViewState state = _goodListKey.currentState;
    // ignore: invalid_use_of_protected_member
    if (state.innerController.positions.length != 1) {
      return;
    }
    final double innerPixels = state.innerController.position.pixels;
    final double outerPixels = state.outerController.position.pixels;

    final Duration innerDuration = Duration(
      milliseconds: (innerPixels / _kBackToTopVelocity)
              .clamp(0, _kBackToTopMaxDuration)
              .toInt() +
          1,
    );

    double exactInnerVelocity;
    if (innerDuration.inMilliseconds == 1) {
      exactInnerVelocity = _kBackToTopVelocity;
    } else {
      exactInnerVelocity = innerPixels / innerDuration.inMilliseconds;
    }

    //assert(exactInnerVelocity >= _kBackToTopVelocity);

    final Duration outerDuration =
        Duration(milliseconds: outerPixels ~/ exactInnerVelocity);

    if (innerPixels > 0.0) {
      await state.innerController
          .animateTo(0.0, duration: innerDuration, curve: Curves.linear);
    }

    if (outerPixels > 0.0) {
      await state.outerController
          .animateTo(0.0, duration: outerDuration, curve: Curves.linear);
    }
  }

  /// ## Internal
  void _firstTimeLoading() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final GlobalGoodsModel model = GlobalGoodsModel.of(context);
      for (int i = 0; i < listTypeCount; i += 1) {
        model.loadMoreGoodsOf(i);
      }
    });
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: List<Widget>.generate(
        listTypeCount,
        (index) => GoodsList(index),
      ),
    );
  }

  void _onFloatButtonTap() {
    final bool isUserLogin = GlobalUserModel.of(context).isUserLogin;
    if (isUserLogin) {
      Navigator.of(context).pushNamed(CollectionPage.routeName);
    } else {
      Navigator.of(context).pushNamed(
        LoginPage.routeName,
        arguments: LoginPageArguments(
          nextPageRouteName: CollectionPage.routeName,
        ),
      );
    }
  }
}
