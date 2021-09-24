import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xtusecondhandmarket/logic/model/global_config_model.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/widget/special/dialog.dart';

import 'tab_bar.dart';
import '../publish_page/publish_page.dart';
import '../profile_page/profile_page.dart';
import '../market_page/market_page.dart';

import '../../widget/common/dim_page_route.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  static const String routeName = '/navigation';
  static Navigation builder(BuildContext context) {
    final Key navigationKey = GlobalConfigModel.of(context).navigationKey;
    return Navigation(key: navigationKey);
  }

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  static const List<Widget> _pages = <Widget>[
    const MarketPage(),
    const PublishPage(),
    const ProfilePage(),
  ];

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0)
      ..addListener(
        PublishPageModel.of(
          context,
        ).focusNodeManager.unFocusAll,
      );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
      body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _pages),
      bottomNavigationBar: NavigationTabBar(
        _pageController,
      ),
    );

    return WillPopScope(
      child: scaffold,
      onWillPop: _handleWillPop,
    );
  }

  Future<bool> _handleWillPop() async {
    final result = await showAlertDialog(
      context: context,
      title: '确认退出？',
      content: '你编辑的内容将会被保存，下一次使用的时候自动恢复',
      leftTitle: '退出',
      rightTitle: '等一下！',
    );

    if (result) {
      _handleExitApp();
    }

    return result;
  }

  void jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }

  Future<void> _handleExitApp() async {
    await PublishPageModel.of(context).localSaveEditing();
    await SystemNavigator.pop();
  }
}


