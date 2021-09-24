import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../widget/special/basic_chip_button.dart';

const String _hintText = '请填写价格';
const int _kMaxInputLength = 6;

class Price extends StatelessWidget {
  const Price();

  @override
  Widget build(BuildContext context) {
    final Widget leading = SizedBox(
      width: kLeadingWidth,
      height: 40.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: kLeadingWidth * 0.3,
            child: Image.asset(
              'assets/img/publish_page/价格icon@hdpi.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '价格',
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

    final Widget oldPrice = OldPriceTextField();

    final Widget newPrice = NewPriceTextField();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              newPrice,
              oldPrice,
            ],
          ),
        ),
      ],
    );
  }
}

abstract class _PriceTextFieldLayout extends PublishPageRegisterWidget {
  static const Widget _padding = const SizedBox(width: 4.0);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final FontData fontData = ThemeModel.of(context).fontData;
    final PublishPageModel model = PublishPageModel.of(context);

    final Widget textField = TextField(
      focusNode: model.focusNodeManager.focusNodeOf(section),
      controller: model.focusNodeManager.controllerOf(section),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: _hintText,
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      onChanged: (String newValue) => _handleOnChange(model,newValue),
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          _kMaxInputLength,
        ),
      ],
    );

    return SizedBox(
      height: 40.0,
      child: Row(
        children: <Widget>[
          Text(
            _title,
            style: fontData.h5_1,
          ),
          _padding,
          Expanded(
            child: Baseline(
              child: textField,
              baselineType: TextBaseline.alphabetic,
              baseline: kLineHeight,
            ),
          ),
          _padding,
          Text(
            '元',
            style: fontData.h5_1,
          )
        ],
      ),
    );
  }

  String get _title;
  void _handleOnChange(PublishPageModel model,String newValue);
}

class OldPriceTextField extends _PriceTextFieldLayout {

  @override
  PublishPageSection get section => PublishPageSection.oldPrice;

  @override
  String get _title => '原价';

  @override
  void _handleOnChange(PublishPageModel model, String newValue) {
    return model.handleOldPriceChange(newValue);
  }
}

class NewPriceTextField extends _PriceTextFieldLayout {

  @override
  PublishPageSection get section => PublishPageSection.newPrice;

  @override
  String get _title => '现价';

  @override
  void _handleOnChange(PublishPageModel model, String newValue) {
    return model.handleNewPriceChange(newValue);
  }
}
