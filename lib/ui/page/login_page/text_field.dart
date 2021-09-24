import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/login_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

final double _kTitleWidth = 60.0;
final double _kLineHeight = 64.0;

abstract class _TextFieldLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final LoginPageModel model = LoginPageModel.of(context);

    final Widget titleWidget = SizedBox(
      width: _kTitleWidth,
      child: Text(
        _title,
        style: fontData.h5_1.copyWith(color: Colors.black),
      ),
    );

    final Widget separator = Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 3.0,
      height: _kLineHeight * 0.3,
      color: Colors.grey.withOpacity(0.6),
    );

    final Widget textField = Selector<LoginPageModel, String>(
      builder: (BuildContext context, String content, Widget child) {
        return TextField(
          focusNode: _getFocusNode(context),
          style: fontData.h5_1,
          onChanged: (String newValue) => _handleContentChange(model, newValue),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _hintText,
          ),
          cursorColor: Theme.of(context).primaryColor,
        );
      },
      selector: _selector,
    );

    return SizedBox(
      height: _kLineHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          titleWidget,
          separator,
          Expanded(
            child: textField,
          )
        ],
      ),
    );
  }

  FocusNode _getFocusNode(BuildContext context);
  String _selector(BuildContext context, LoginPageModel model);
  void _handleContentChange(LoginPageModel model, String newValue);
  String get _hintText;
  String get _title;
}

class SidTextField extends _TextFieldLayout {
  @override
  void _handleContentChange(LoginPageModel model, String newValue) {
    return model.handleSidChange(newValue);
  }

  @override
  String _selector(BuildContext context, LoginPageModel model) {
    return model.sid;
  }

  @override
  String get _hintText => '请输入学号';

  @override
  String get _title => '学号';

  @override
  FocusNode _getFocusNode(BuildContext context) {
    return LoginPageModel.of(context).sidFocusNode;
  }
}

class PasswordTextField extends _TextFieldLayout {
  @override
  void _handleContentChange(LoginPageModel model, String newValue) {
    return model.handlePasswordChange(newValue);
  }

  @override
  String _selector(BuildContext context, LoginPageModel model) {
    return model.sid;
  }

  @override
  String get _hintText => '请输入密码';

  @override
  String get _title => '密码';

  @override
  FocusNode _getFocusNode(BuildContext context) {
    return LoginPageModel.of(context).passwordFocus;
  }
}
