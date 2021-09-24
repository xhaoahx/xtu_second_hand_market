import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme_config.dart';

export '../config/theme_config.dart';

/// Todo: Once theme become changeable, alter this class to [ChangeNotifier]
class ThemeModel{

  ThemeData get materialThemeData => ThemeConfig.asMaterialThemeData();
  CupertinoThemeData get cupertinoThemeData => ThemeConfig.asCupertinoThemeData();

  /// ## Method
  static ThemeModel of(BuildContext context,{bool listen = false}) => Provider.of<ThemeModel>(context,listen:listen);


  final FontData fontData = FontData();
}