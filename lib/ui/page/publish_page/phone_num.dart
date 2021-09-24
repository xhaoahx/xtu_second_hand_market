import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../widget/special/basic_chip_button.dart'
    show kLineHeight, kTextFontSize;

class PhoneNum extends PublishPageRegisterWidget {
  const PhoneNum();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ThemeData themeData = Theme.of(context);
    final PublishPageModel model = PublishPageModel.of(context);

    final Widget leading = SizedBox(
      width: 100.0,
      height: kLineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 24.0,
            child: Image.asset(
              'assets/img/publish_page/手机号码@hdpi.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '电话号码',
                style: ThemeModel.of(context).fontData.h4_4.copyWith(
                      fontSize: kTextFontSize,
                      color: Colors.grey,
                    ),
              ),
            ),
          )
        ],
      ),
    );

    final Widget textField = SizedBox(
      height: 40.0,
      child: TextField(
        focusNode: model.focusNodeManager.focusNodeOf(section),
        controller: model.focusNodeManager.controllerOf(section),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '请填写手机号码',
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        minLines: 1,
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(11),
        ],
        cursorColor: themeData.primaryColor,
        onChanged: model.handlePhoneNumChange,
        autofocus: false,
        maxLengthEnforced: true,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
      )
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: Baseline(
            child: textField,
            baselineType: TextBaseline.alphabetic,
            baseline: kLineHeight,
          )
        ),
      ],
    );
  }

  @override
  PublishPageSection get section => PublishPageSection.phoneNum;
}
