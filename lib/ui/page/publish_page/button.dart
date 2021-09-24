import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/ui/page/login_page/login_page.dart';
import 'package:xtusecondhandmarket/ui/widget/special/alert_snake_bar.dart';
import 'package:xtusecondhandmarket/ui/widget/special/dialog.dart';
import '../../../logic/model/theme_model.dart';

const double _kButtonHeight = 48.0;

class PublishButton extends StatelessWidget {
  const PublishButton();

  @override
  Widget build(BuildContext context) {
    final double radius = _kButtonHeight * 0.5;

    final ThemeData themeData = Theme.of(context);
    return Center(
      child: Container(
        height: _kButtonHeight,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: themeData.primaryColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 4.0,
              color: themeData.primaryColor.withOpacity(0.6),
              offset: Offset(0.0,4.0),
            )
          ]
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: themeData.accentColor,
              onTap: () {
                _handleOnTap(context);
              },
              child: Center(
                child: Text(
                  '发布',
                  style: ThemeModel.of(context).fontData.h4_4.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context) async {
    final bool isLogin = GlobalUserModel.of(context).isUserLogin;
    if (isLogin) {
      final bool confirm = await showConfirmDialog(
        context: context,
        leftTitle: '拒绝',
        rightTitle: '确认',
        imgUr: 'assets/img/publish_page/确定接听@hdpi.png',
      );

      if (confirm) {
        final PublishResult result =
            await PublishPageModel.of(context).handlePublish();
        OverlayEntry snakeBarEntry;
        snakeBarEntry = OverlayEntry(
          builder: (BuildContext context) => AlertSnakeBar(
            text: publishResultToString(result),
            onEnd: snakeBarEntry.remove,
          ),
        );
        Overlay.of(context).insert(snakeBarEntry);
      }
    } else {
      Navigator.of(context).pushNamed(LoginPage.routeName);
    }
  }
}
