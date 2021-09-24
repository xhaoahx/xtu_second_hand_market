import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import '../../../logic/manager/publish_page_manager.dart';

const String _hintText = '请输入宝贝标题（说重点喔！）';
const int _kMaxInputLength = 20;

class GoodsTitle extends PublishPageRegisterWidget {
  const GoodsTitle();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final PublishPageModel model = PublishPageModel.of(context);
    final ThemeData themeData = Theme.of(context);

    final Widget textField = TextField(
      controller: model.focusNodeManager.controllerOf(section),
      focusNode: model.focusNodeManager.focusNodeOf(section),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: _hintText,
      ),
      textInputAction: TextInputAction.done,
      cursorColor: themeData.primaryColor,
      onChanged: model.handleTitleChange,
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          _kMaxInputLength,
        ),
      ],
    );

    final Widget counter = Selector<PublishPageModel, int>(
      builder: (BuildContext context, int length, Widget child) {
        return Text(
          '$length/$_kMaxInputLength',
          style: ThemeModel.of(context).fontData.h5_2.copyWith(
                color: _kMaxInputLength == length ? Colors.red : null,
              ),
        );
      },
      selector: (BuildContext context, PublishPageModel model) =>
          model.title?.length ?? 0,
    );

    final Widget checkBox = Selector<PublishPageModel, bool>(
      builder: (BuildContext context, bool isNew, Widget child) {
        return Checkbox(
          value: model.isNew ?? false,
          onChanged: model.handleIsNewChange,
        );
      },
      selector: (BuildContext context, PublishPageModel model) => model.isNew,
    );

    return Row(
      children: <Widget>[
        Expanded(child: textField),
        counter,
        checkBox,
        Text('全新')
      ],
    );
  }

  @override
  PublishPageSection get section => PublishPageSection.title;
}
