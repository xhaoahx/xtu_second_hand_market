import 'package:flutter/material.dart';
import '../logic/config/theme_config.dart';


class FontTest extends StatelessWidget {


  final FontData fontData = FontData();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fontData.textStyles.map<Widget>((style) => Text(
        'Test',
        style: style,
        textAlign: TextAlign.left,
      )).toList(),
    );
  }
}
