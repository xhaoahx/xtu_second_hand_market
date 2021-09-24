import 'package:flutter/material.dart' hide ButtonBar;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';

import 'appbar.dart';
import 'header.dart';
import 'banner.dart';
import 'goods_info.dart';
import 'description.dart';
import 'pinned_title.dart';
import 'comment.dart';
import 'button.dart';

const Duration kTransDuration = Duration(milliseconds: 400);
const double kHeaderHeight = 64.0;
const double kBannerHeight = 320.0;
const double kInfoHeight = 80.0;

class GoodsDetailsPage extends StatelessWidget {
  static const String routeName = '/details_page';
  static GoodsDetailsPage builder(BuildContext context) => GoodsDetailsPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailsPageModel>(
      create: (BuildContext context) => DetailsPageModel(),
      child: _GoodsDetailsPage(),
    );
  }
}

class _GoodsDetailsPage extends StatefulWidget {
  @override
  _GoodsDetailsPageState createState() => _GoodsDetailsPageState();
}

class _GoodsDetailsPageState extends State<_GoodsDetailsPage> {
  OverlayEntry _contentEntry;
  OverlayEntry _buttonsEntry;

  Widget _buttons;

  @override
  void initState() {
    super.initState();
    _buttons = Positioned(
      left: 20.0,
      bottom: 20.0,
      right: 20.0,
      child: ButtonBar(),
    );
    _contentEntry = OverlayEntry(
      builder: (BuildContext context){
        return Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: GoodsDetailsPageContent(),
        );
      },
    );
    _buttonsEntry = OverlayEntry(
      builder: (BuildContext context) => _buttons,
    );
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        key: DetailsPageModel.of(context).overlayKey,
        initialEntries: <OverlayEntry>[
          _contentEntry,
          _buttonsEntry,
        ],
      ),
      color: Colors.white,
    );
  }

  void _firstLoad() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final ShortGoodsDetails details =
          ModalRoute.of(context).settings.arguments;
      DetailsPageModel.of(context).initPage(details);
    });
  }
}

class GoodsDetailsPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget scrollView = CustomScrollView(
      controller: DetailsPageModel.of(context).scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              DetailsHeader(),
              DetailsBanner(),
              GoodsInfo(),
              const SizedBox(height: 8.0),
              Description(),
            ],
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: PinnedTitleDelegate(),
        ),
        Comments(),
      ],
    );

    return Column(
      children: <Widget>[
        DetailsAppBar(),
        Expanded(
          child: scrollView,
        ),
      ],
    );
  }
}
