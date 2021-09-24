import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/login_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../user_agreement_page/user_agreement_page.dart';

class AgreementWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final LoginPageModel model = LoginPageModel.of(context);

    final Widget icon = SizedBox(
      width: 16.0,
      height: 16.0,
      child: Image.asset('assets/img/login_page/提示@hdpi.png'),
    );

    final Widget part1 = Text(
      '我已经认真阅读',
      style: fontData.h5_1.copyWith(color: Colors.black),
    );

    final Widget part2 = GestureDetector(
      child: Text(
        '《使用许可协议》',
        style: fontData.h5_1.copyWith(color: Colors.blue),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(UserAgreementPage.routeName);
      },
    );

    final Widget checkBox = Selector<LoginPageModel, bool>(
      builder: (BuildContext context, bool selected, Widget child) {
        return Checkbox(
          value: selected,
          onChanged: model.handleAgreement,
        );
      },
      selector: (BuildContext context, LoginPageModel model) {
        return model.hasReadAgreement;
      },
    );

    return Row(
      children: <Widget>[
        icon,
        const SizedBox(width: 6.0),
        part1,
        part2,
        checkBox,
      ],
    );
  }
}
