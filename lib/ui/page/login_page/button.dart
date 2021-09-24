import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/login_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';
import 'package:xtusecondhandmarket/ui/widget/common/dim_page_route.dart';

const Duration _kDialogDuration = Duration(milliseconds: 1200);

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginPageArguments arguments =
        ModalRoute.of(context).settings.arguments as LoginPageArguments;

    final Widget buttonContent = Selector<LoginPageModel, bool>(
      builder: (BuildContext context, bool loading, Widget child) {
        final FontData fontData = ThemeModel.of(context).fontData;

        final Widget loadingWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              '登录中，请稍后...',
              style: fontData.h4_4,
            )
          ],
        );

        final Widget idleWidget = Text(
          '登录',
          style: fontData.h4_4,
        );

        return AnimatedSwitcher(
          child: loading ? loadingWidget : idleWidget,
          duration: const Duration(milliseconds: 300),
        );
      },
      selector: (BuildContext context, LoginPageModel model) {
        return model.isLoading;
      },
    );

    return Selector<LoginPageModel, bool>(
      builder: (BuildContext context, bool enabled, Widget child) {
        Future<void> handleOnTap() async {
          LoginPageModel.of(context).unFocusAll();
          final bool succeed = await _handleLogin(context);
          if (succeed) {
            await _showDialog(context);
            _handleToNextPage(context, arguments);
          }
        }

        final Color themeColor = Theme.of(context).primaryColor;
        return FlatButton(
          color: themeColor,
          disabledColor: themeColor.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999.0)),
          onPressed: enabled ? handleOnTap : null,
          child: child,
        );
      },
      selector: (BuildContext context, LoginPageModel model) {
        return model.enableButton;
      },
      child: Center(
        child: buttonContent,
      ),
    );
  }

  Future<bool> _handleLogin(BuildContext context) async {
    final LoginPageModel model = LoginPageModel.of(context);
    LoginResult loginResult = await model.handleLogin();

    if (loginResult != null) {
      switch (loginResult) {
        case LoginResult.succeed:
          return true;
        default:

          /// todo: implement show alert
          break;
      }
    }
    return false;
  }

  Future<void> _showDialog(BuildContext context) async {
    Navigator.of(context).push(DimPageRoute(
      builder: (BuildContext context) => _SucceedDialog(),
      defaultPopValue: null,
    ));
    return Future.delayed(_kDialogDuration + Duration(milliseconds: 400));
  }

  void _handleToNextPage(BuildContext context, LoginPageArguments arguments) {
    final GlobalUserModel userModel = GlobalUserModel.of(context);
    final LoginPageModel model = LoginPageModel.of(context);

    userModel.handleLoginSucceed(model.asStorageUser());
    if (arguments != null) {
      Navigator.of(context).pushReplacementNamed(
        arguments.nextPageRouteName,
        arguments: arguments.nextPageArguments,
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}

class _SucceedDialog extends StatefulWidget {
  @override
  __SucceedDialogState createState() => __SucceedDialogState();
}

class __SucceedDialogState extends State<_SucceedDialog> {
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_kDialogDuration).then((_) {
      _popDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _popDialog,
      child: Image.asset(
        'assets/img/login_page/登录成功@hdpi.png',
        fit: BoxFit.contain,
      ),
    );
  }

  void _popDialog() {
    if (!_isPopped) {
      _isPopped = true;
      Navigator.of(context).pop();
    }
  }
}
