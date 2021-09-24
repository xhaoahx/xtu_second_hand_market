import 'package:flutter/material.dart';

import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/logic/model/collection_page_model.dart';

import 'package:xtusecondhandmarket/logic/model/global_config_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/navigation/navigation.dart';

import 'collection_page_item.dart';
import '../../widget/special/profile_page_basic_layout.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage();

  static const String routeName = 'collection_page';
  static CollectionPage builder(BuildContext context) => CollectionPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CollectionPageModel(),
      child: _CollectionPage(),
    );
  }
}

class _CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<_CollectionPage> {
  Widget _content;
  OverlayEntry _contentEntry;

  @override
  void initState() {
    super.initState();
    _content = _CollectionPageContent();
    _contentEntry = OverlayEntry(
      builder: (BuildContext context) => _content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[_contentEntry],
    );
  }
}

class _CollectionPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfilePageBasicLayout<CollectionPageModel, FullGoodsDetails>(
      itemBuilder: _itemBuilder,
      emptyStatusBuilder: _buildEmptyStatus,
      title: '我的收藏',
      headerTitle: ',这是你喜欢的宝贝',
      headerSubTitle: '常来看看哦',
      selector: _selector,
      indicatorSelector: _indicatorSelector,
      firstTimeLoadingCallback: _firstTimeLoadingCallback,
    );
  }

  Widget _itemBuilder(BuildContext context, FullGoodsDetails details) {
    return CollectionPageItem(
      key: GlobalObjectKey(details.id),
      details: details,
    );
  }

  Widget _buildEmptyStatus(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.asset(
          'assets/img/collection_page/无收藏@hdpi.png',
          fit: BoxFit.contain,
        ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            final NavigationState state =
                GlobalConfigModel.of(context).navigationKey.currentState;
            state.jumpToPage(0);
            Navigator.of(context).pop();
          },
          child: Text(
            '去逛逛',
            style: ThemeModel.of(context).fontData.h4_4,
          ),
        ),
      ],
    );

    return Center(
      child: SizedBox(width: 200.0, child: content),
    );
  }

  Tuple2<List<FullGoodsDetails>, Object> _selector(
      BuildContext context, CollectionPageModel model) {
    return Tuple2<List<FullGoodsDetails>, Object>(
      model.collection,
      model.isCollectionChanged,
    );
  }

  bool _indicatorSelector(BuildContext context, CollectionPageModel model) {
    return model.isLoading;
  }

  void _firstTimeLoadingCallback(BuildContext context) {
    final CollectionPageModel model = CollectionPageModel.of(context);
    final int userId = GlobalUserModel.of(context).user.id;
    model.loadCollection(userId);
  }
}
