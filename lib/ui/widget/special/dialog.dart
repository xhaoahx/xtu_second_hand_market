import 'package:flutter/material.dart';

import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/widget/common/dim_page_route.dart';

Future<bool> showConfirmDialog({
  BuildContext context,
  String leftTitle,
  String rightTitle,
  String imgUr,
}) {
  return Navigator.of(context).push<bool>(
    DimPageRoute(
      builder: (BuildContext context) => ConfirmDialog(
        leftTitle: leftTitle,
        rightTitle: rightTitle,
        imgUrl: imgUr,
      ),
      defaultPopValue: false,
    ),
  );
}

Future<bool> showAlertDialog({
  BuildContext context,
  String leftTitle,
  String rightTitle,
  String title,
  String content,
}) {
  return Navigator.of(context).push<bool>(
    DimPageRoute(
      builder: (BuildContext context) => AlertDialog(
        leftTitle: leftTitle,
        rightTitle: rightTitle,
        content: content,
        title: title,
      ),
      defaultPopValue: false,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    Key key,
    this.imgUrl,
    this.leftTitle,
    this.rightTitle,
  }) : super(key: key);

  final String leftTitle;
  final String rightTitle;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.asset(
      imgUrl,
      fit: BoxFit.cover,
    );

    final Widget dialog = Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: image),
          Row(
            children: <Widget>[
              _buildButton(context, leftTitle, false),
              _buildButton(context, rightTitle, true),
            ],
          ),
        ],
      ),
      color: Colors.transparent,
    );

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 280.0,
          maxHeight: 340.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0.0, 2.0),
              )
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: dialog,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, bool result) {
    final FontData fontData = ThemeModel.of(context).fontData;

    final Widget button = FlatButton(
      padding: const EdgeInsets.all(0.0),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pop<bool>(result);
      },
      child: Text(
        text,
        style: result ? fontData.h4_1 : fontData.h4_4,
      ),
    );

    return Expanded(
      child: SizedBox(
        height: 40.0,
        child: button,
      ),
    );
  }
}

class AlertDialog extends StatelessWidget {
  const AlertDialog({
    Key key,
    this.rightTitle,
    this.leftTitle,
    this.title,
    this.content,
  });

  final String title;
  final String content;
  final String leftTitle;
  final String rightTitle;

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final Widget titleWidget = Row(
      children: <Widget>[
        SizedBox(
          height: 26.0,
          child: Image.asset(
            'assets/img/navigation/alert_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        Text(
          title,
          style: fontData.h3_1,
        ),
      ],
    );

    final Widget buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildButton(context, leftTitle, true),
        _buildButton(context, rightTitle, false),
      ],
    );

    final Widget alert = SizedBox(
      height: 75.0,
      child: Text(
        content,
        style: fontData.h4_4.copyWith(
          color: Colors.grey,
        ),
      ),
    );

    final Widget dialog = Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: titleWidget,
          ),
          Divider(
            height: 1.0,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: alert,
          ),
          buttons,
        ],
      ),
    );

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 280.0,
          maxHeight: 160.0,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 4.0),
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: dialog,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, bool quit) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final ThemeData themeData = Theme.of(context);

    final Widget button = FlatButton(
      padding: const EdgeInsets.all(0.0),
      color: quit ? themeData.primaryColor : themeData.accentColor,
      onPressed: () {
        Navigator.of(context).pop<bool>(quit);
      },
      child: Text(
        text,
        style: fontData.h4_2.copyWith(color: Colors.white),
      ),
    );

    return Expanded(
      child: SizedBox(
        height: 40.0,
        child: button,
      ),
    );
  }
}
