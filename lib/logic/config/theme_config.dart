import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';

class ThemeConfig{
  static const primaryThemeColor = Color(0xFFFFE896);
  static const accentThemeColor = Color(0xFFFED269);

  static ThemeData asMaterialThemeData(){
    return ThemeData.from(
      colorScheme: ColorScheme(
        primary: primaryThemeColor,
        primaryVariant: primaryThemeColor,
        secondary: accentThemeColor,
        secondaryVariant: accentThemeColor,

        background: Colors.white,
        surface: Colors.white70,
        error: Colors.yellow,

        onError: Colors.red,
        onSurface: Colors.black87,
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onBackground: Colors.black87,

        brightness: Brightness.light
      )
    );
  }

  static CupertinoThemeData asCupertinoThemeData(){
    throw UnimplementedError();
  }
}


class FontData{
  static const fontPath = 'assets/font/msyh.ttf';

  List<TextStyle> get textStyles => [
    h1_1,
    h1_2,
    h2_1,
    h2_2,
    h3_1,
    h3_2,
    h4_1,
    h4_2,
    h4_3,
    h4_4,
    h5_1,
    h5_2,
    h5_3,
    h5_4,
  ];

  static const TextStyle baseTextStyle = TextStyle(
    fontFamily: 'msyh', // 微软雅黑
    fontWeight: FontWeight.normal,
  );

  final TextStyle h1_1 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 44.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);

  final TextStyle h1_2 = TextStyle(
    color: Color(0xFF3F3F3F),
      fontSize: 44.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);



  final TextStyle h2_1 = TextStyle(
    color: Color(0xFF000000),
      fontSize: 28.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);

  final TextStyle h2_2 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);


  final TextStyle h3_1 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);

  final TextStyle h3_2 = TextStyle(
    color: Color(0xFF3F3F3F),
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);



  final TextStyle h4_1 = TextStyle(
    color: Color(0xFFFF7911),
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);

  final TextStyle h4_2 = TextStyle(
    color: Color(0xFFFF7911),
    fontSize: 16.0,
  ).merge(baseTextStyle);

  final TextStyle h4_3 = TextStyle(
    color: Color(0xFFFFE896),
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ).merge(baseTextStyle);

  final TextStyle h4_4 = TextStyle(
    color: Color(0xFF3F3F3F ),
    fontSize: 16.0,
  ).merge(baseTextStyle);



  final TextStyle h5_1 = TextStyle(
    color: Color(0xFF3F3F3F),
    fontSize: 12.0,
  ).merge(baseTextStyle);

  final TextStyle h5_2 = TextStyle(
    color: Color(0xFFBBBBBB),
    fontSize: 12.0,
  ).merge(baseTextStyle);

  final TextStyle h5_3 = TextStyle(
    color: Color(0xFFBBBBBB),
    fontSize: 12.0,
  ).merge(baseTextStyle);

  final TextStyle h5_4 = TextStyle(
    color: Color(0xFFE02020),
    fontSize: 12.0,
  ).merge(baseTextStyle);
}
