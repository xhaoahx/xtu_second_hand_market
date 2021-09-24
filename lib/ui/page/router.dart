import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/ui/page/collection_page/collection_page.dart';
import 'package:xtusecondhandmarket/ui/page/goods_details_page/goods_details_page.dart';
import 'package:xtusecondhandmarket/ui/widget/common/fade_in_page_route.dart';

import 'login_page/login_page.dart';
import 'user_agreement_page/user_agreement_page.dart';
import 'navigation/navigation.dart';
import 'picture_display_page/picture_display_page.dart';
import 'classification_page/classification_page.dart';
import 'search_page/search_page.dart';

class Router {
  static const String navigation = Navigation.routeName;

  static const Map<String, WidgetBuilder> _routeTable = {
    ClassificationPage.routeName: ClassificationPage.builder,
    PictureDisplayPage.routeName: PictureDisplayPage.builder,
    SearchPage.routeName: SearchPage.builder,
    GoodsDetailsPage.routeName: GoodsDetailsPage.builder,
    Navigation.routeName: Navigation.builder,
    UserAgreementPage.routeName : UserAgreementPage.builder,
    LoginPage.routeName : LoginPage.builder,
    CollectionPage.routeName : CollectionPage.builder
  };

  static Route<void> handleGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name;
    final WidgetBuilder builder = _routeTable[routeName];

    if (routeName == navigation) {
      assert(builder != null);
      return FadeInPageRoute(builder);
    }

    if (builder != null) {
      return CupertinoPageRoute(
        builder: builder,
        settings: settings,
        title: settings.name,
      );
    } else {
      // Unknown route
      assert(false);
      return MaterialPageRoute(builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Text('unknown route'),
        );
      });
    }
  }
}
