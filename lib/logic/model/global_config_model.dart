import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/ui/page/navigation/navigation.dart';

/// Todo: Once theme become changeable, alter this class to [ChangeNotifier]
class GlobalConfigModel {
  static GlobalConfigModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<GlobalConfigModel>(context, listen: listen);

  final GlobalKey<NavigationState> navigationKey =
      GlobalKey(debugLabel: 'navigation_key');
}
