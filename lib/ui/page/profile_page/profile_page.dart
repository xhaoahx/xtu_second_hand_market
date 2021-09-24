import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';
import 'package:xtusecondhandmarket/ui/page/profile_page/user_info.dart';

import 'item_widget.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final bool isLogin = GlobalUserModel.of(context).isUserLogin;
      if(!isLogin){
        Navigator.of(context).pushNamed(LoginPage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget result =  LayoutBuilder(
      builder: (BuildContext context,BoxConstraints constraints){

        final double width = constraints.biggest.width;

        final Widget appbar = Container(
          height: 86.0,
          child: SafeArea(
            child: Center(
              child: Text(
                '我的',
                style: ThemeModel.of(context).fontData.h3_1,
              ),
            ),
          ),
        );

        final Widget userInfo = UserInfo();

        final Widget bgDecoration = Image.asset(
          'assets/img/profile_page/背景@hdpi.png',
          fit: BoxFit.cover,
        );

        final Widget itemWidget = Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: ItemWidget(),
        );

        return Material(
          color: ThemeConfig.primaryThemeColor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0.0,
                height: 86.0,
                left: 0.0,
                right: 0.0,
                child: appbar,
              ),
              Positioned(
                left: width * 0.384,
                top: 91.0,
                height: width * 0.47,
                width: width * 0.47,
                child: bgDecoration,
              ),
              Positioned(
                top: 86.0,
                left: 25.0,
                right: 25.0,
                height: 130.0,
                child: userInfo,
              ),
              Positioned(
                left: 13.0,
                right: 13.0,
                top: 130.0 + 86.0,
                bottom: 0.0,
                child: itemWidget,
              ),
            ],
          ),
        );
      },
    );

    return result;
  }
}
