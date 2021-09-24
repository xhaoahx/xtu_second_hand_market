import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/global_config_model.dart';

import 'logic/model/publish_page_model.dart';
import 'logic/model/global_goods_model.dart';
import 'logic/model/theme_model.dart';
import 'logic/model/global_user_model.dart';

import 'ui/page/router.dart';
import 'ui/page/splash_page/splash_page.dart';

class XtuSecondHandMarketApp extends StatelessWidget {
  static const String appTitle = '湘大二手街';

  final ThemeModel themeModel = ThemeModel();
  final GlobalConfigModel configModel = GlobalConfigModel();

  @override
  Widget build(BuildContext context) {
    final Widget app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: themeModel.materialThemeData,
      home: SplashPage(),
      onGenerateRoute: Router.handleGenerateRoute,
    );

    return MultiProvider(
      providers: [
        Provider<GlobalConfigModel>.value(
          value: configModel,
        ),
        Provider<ThemeModel>.value(
          value: themeModel,
        ),
        ChangeNotifierProvider<GlobalUserModel>(
          create: (context) => GlobalUserModel(),
        ),
        ChangeNotifierProvider<GlobalGoodsModel>(
          create: (context) => GlobalGoodsModel(),
        ),
        ChangeNotifierProvider<PublishPageModel>(
          create: (context) => PublishPageModel(),
        )
      ],
      child: app,
    );
  }
}
