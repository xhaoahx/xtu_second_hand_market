import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/login_page_model.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/agreement_widget.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/button.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_title.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/text_field.dart';
import 'package:xtusecondhandmarket/ui/widget/common/animated_list_wrapper.dart';

const String _typeKey = 'login_page_sliver';

class LoginPageArguments {
  const LoginPageArguments({
    this.nextPageArguments,
    this.nextPageRouteName,
  });

  final String nextPageRouteName;
  final Object nextPageArguments;
}

class LoginPage extends StatelessWidget {
  static const String routeName = '/login_page';
  static LoginPage builder(BuildContext context) => LoginPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginPageModel>(
      create: (BuildContext context) => LoginPageModel(),
      child: _LoginPageContent(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  OverlayEntry _contentEntry;
  Widget _content;

  @override
  void initState() {
    super.initState();
    _content = _LoginPageContent();
    _contentEntry = OverlayEntry(
      builder: (BuildContext context) => _content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[_contentEntry],
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget appBar = Container(
      height: 86.0,
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: Navigator.of(context).pop,
            ),
            Text(
              '授权认证',
            )
          ],
        ),
      ),
    );

    final Widget title = LoginTitle();

    final Widget sid = SidTextField();

    final Widget password = PasswordTextField();

    final Widget agreement = AgreementWidget();

    final Widget button = LoginButton();

    final List<Widget> children = <Widget>[
      const SizedBox(height: 60.0),
      title,
      const SizedBox(height: 60.0),
      sid,
      password,
      const SizedBox(height: 40.0),
      agreement,
      button,
    ].map<Widget>((Widget child){
      return AnimatedSliverWrapper(
        forwardCurve: Curves.decelerate,
        factor: 0.3,
        builder: (BuildContext context) => child,
        typeKey: _typeKey,
      );
    }).toList(growable: false);

    final Widget content = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      children: children,
    );

    return Material(
      color: Colors.white,
      // allow page to scroll
      child: Selector<LoginPageModel, bool>(
        builder: (BuildContext context, bool loading, Widget child) {
          return IgnorePointer(
            ignoring: loading,
            child: child,
          );
        },
        selector: (BuildContext context, LoginPageModel model) {
          return model.isLoading;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            appBar,
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
