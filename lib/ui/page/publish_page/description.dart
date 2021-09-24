import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import '../../../logic/manager/publish_page_manager.dart';

const String _hintText = '宝贝新旧程度，入手渠道，转手原因，品牌型号...';
const int _kMaxInputLength = 120;

class Description extends PublishPageRegisterWidget {
  const Description();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final PublishPageModel model = PublishPageModel.of(context);
    final ThemeData themeData = Theme.of(context);

    final Widget textField = Selector<PublishPageModel, String>(
      builder: (BuildContext context, String title, Widget child) {
        return TextField(
          focusNode: model.focusNodeManager.focusNodeOf(section),
          controller: model.focusNodeManager.controllerOf(section),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: _hintText,
          ),
          textInputAction: TextInputAction.done,
          maxLength: _kMaxInputLength,
          minLines: 1,
          maxLines: 10,
          cursorColor: themeData.primaryColor,
          onChanged: model.handleDescriptionChange,
          autofocus: false,
          maxLengthEnforced: true,
          buildCounter: (
            BuildContext context, {
            int currentLength,
            int maxLength,
            bool isFocused,
          }) {
            final FontData fontData = ThemeModel.of(context).fontData;
            return Text(
              '$currentLength/$maxLength',
              style: fontData.h5_2.copyWith(
                color: _kMaxInputLength == currentLength ? Colors.red : null,
              ),
            );
          },
        );
      },
      selector: (BuildContext context, PublishPageModel model) {
        return model.description;
      },
    );

    return textField;
  }

  @override
  PublishPageSection get section => PublishPageSection.description;
}
