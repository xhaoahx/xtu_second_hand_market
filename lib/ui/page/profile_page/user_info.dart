import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';
import 'package:xtusecondhandmarket/ui/widget/common/dim_page_route.dart';
import 'package:xtusecondhandmarket/ui/widget/special/dialog.dart';

const double _kUserNameWidth = 120.0;
const double _kAvatarSize = 56.0;

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalUserModel userModel = GlobalUserModel.of(context);
    final FontData fontData = ThemeModel.of(context).fontData;

    return Selector<GlobalUserModel, bool>(
      builder: (BuildContext context, bool isUserLogin, Widget child) {
        Widget userName, welcome, avatar;

        if (isUserLogin) {
          userName = SizedBox(
            width: _kUserNameWidth,
            child: Text(
              userModel.user.name,
              style: fontData.h4_4,
              overflow: TextOverflow.ellipsis,
            ),
          );

          welcome = Text(
            ' ,欢迎来到二手街',
            style: fontData.h4_4,
          );

          avatar = SizedBox(
            width: _kAvatarSize,
            height: _kAvatarSize,
            child: CachedNetworkImage(
              imageUrl: userModel.user.avatarUrl,
              imageBuilder:
                  (BuildContext context, ImageProvider<dynamic> provider) {
                return CircleAvatar(
                  backgroundImage: provider,
                  radius: _kAvatarSize * 0.5,
                );
              },
            ),
          );
        } else {
          userName = SizedBox(
            width: _kUserNameWidth,
            child: Text(
              '请先登录',
              style: fontData.h4_4,
              overflow: TextOverflow.ellipsis,
            ),
          );

          welcome = const SizedBox();

          avatar = const SizedBox(
            width: _kAvatarSize,
            height: _kAvatarSize,
          );
        }

        final Widget operateButton = GestureDetector(
          child: Text(
            isUserLogin ? '退出登录' : '登录',
            style: fontData.h5_4.copyWith(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            if (isUserLogin) {
              _handleUnLogin(context);
            } else {
              _handleLogin(context);
            }
          },
        );

        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                userName,
                Expanded(
                  child: welcome,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                operateButton,
                avatar,
              ],
            )
          ],
        );
      },
      selector: (BuildContext context, GlobalUserModel model) {
        return model.isUserLogin;
      },
    );
  }

  void _handleLogin(BuildContext context) {
    Navigator.of(context).pushNamed(LoginPage.routeName);
  }

  Future<void> _handleUnLogin(BuildContext context) async {
    final result = await showAlertDialog(
      context: context,
      title: '确认退出登录？',
      content: '退出登录后，需要重新登录才能正常使用哦！',
      leftTitle: '退出',
      rightTitle: '等一下！',
    );

    if (result) {
      GlobalUserModel.of(context).handleUnLogin();
    }
  }
}
