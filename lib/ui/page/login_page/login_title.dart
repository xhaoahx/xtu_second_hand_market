import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../widget/common/decorated_text.dart';

class LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final FontData fontData = ThemeModel.of(context).fontData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedText(
          TextSpan(
            text: '欢迎来到湘大二手街!',
            style: fontData.h3_1.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          '全新打造『湘大人自己的跳蚤市场』',
          style: fontData.h5_1
        ),
      ],
    );
  }
}
