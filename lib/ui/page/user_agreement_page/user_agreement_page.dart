import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserAgreementPage extends StatelessWidget{

  static const String routeName = '/user_agreement_page';
  static UserAgreementPage builder(BuildContext context) => UserAgreementPage();

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
              '湘大二手街',
            ),
          ],
        ),
      ),
    );

    final Widget content = SingleChildScrollView(
      child: Image.asset(
        'assets/img/login_page/用户协议.jpg',
        fit: BoxFit.fitWidth,
      ),
    );

    return Material(
      child: Column(
        children: <Widget>[
          appBar,
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}