import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:xtusecondhandmarket/ui/page/search_page/search_page.dart';

import 'app_bar.dart';
import 'goods_list.dart';
import '../../widget/special/pinned_tab_bar.dart';
import '../../widget/common/enhanced_nsv.dart';
import '../../../logic/model/global_goods_model.dart';
import '../../../logic/model/theme_model.dart';

const List<String> _bannerPath = [
  'assets/img/classification_page/图书教材@hdpi.png',
  'assets/img/classification_page/家用电器@hdpi.png',
  'assets/img/classification_page/数码产品@hdpi.png',
  'assets/img/classification_page/美妆日化@hdpi.png',
  'assets/img/classification_page/衣物鞋帽@hdpi.png',
  'assets/img/classification_page/生活用品@hdpi.png',
];

const double _kHeaderHeight = 200.0;

class ClassificationPage extends StatefulWidget {
  static const String routeName = 'classification_page';
  static ClassificationPage builder(BuildContext context) =>
      ClassificationPage();

  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  int _classification;
  List<String> _allTypes;

  @override
  void initState() {
    super.initState();
    _firstTimeLoading(_classification);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _classification = ModalRoute.of(context).settings.arguments;
    _allTypes = allTypesOf(_classification);
  }

  @override
  Widget build(BuildContext context) {
    final Widget appBar = ClassificationPageAppBar(
      title: classificationToString(_classification),
      onTap: _onTapBack,
    );

    final Widget banner = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Image.asset(_bannerPath[_classification]),
    );

    final Widget searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: FlatButton(
        onPressed: _onTapSearch,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
            side: BorderSide(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            Text(
              '在类目下搜索',
              style: ThemeModel.of(context).fontData.h4_4.copyWith(
                    color: Colors.grey,
                  ),
            ),
            SizedBox(
              width: 15.0,
            )
          ],
        ),
      ),
    );

    final Widget listBody = DefaultTabController(
      child: EnhancedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: _kHeaderHeight,
                child: Column(
                  children: <Widget>[
                    banner,
                    searchBar,
                  ],
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: EnhancedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverPersistentHeader(
                delegate: PinnedTabBarDelegate(factor: 1.0, titles: _allTypes),
                pinned: true,
              ),
            ),
          ];
        },
        body: _buildTabBarView(),
      ),
      length: _allTypes.length,
    );

    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: appBar,
            left: 0.0,
            right: 0.0,
            height: 86.0,
          ),
          Positioned(
            top: 86.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: listBody,
          )
        ],
      ),
      color: Colors.white,
    );
  }

  void _onTapBack() {
    GlobalGoodsModel.of(context).clearTypedGoods();
    Navigator.of(context).pop();
  }

  void _onTapSearch() {
    Navigator.of(context).pushNamed(SearchPage.routeName);
  }

  void _firstTimeLoading(int classification) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final GlobalGoodsModel model = GlobalGoodsModel.of(context);
      model.loadTypedGoods(classification);
    });
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: List.generate(
        typeCountOf(_classification),
        (index) => GoodsList(_classification, index),
      ),
    );
  }
}
