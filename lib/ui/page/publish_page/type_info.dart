import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/common/goods.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import '../../widget/special/basic_chip_button.dart';

class TypeInfo extends PublishPageRegisterWidget {
  const TypeInfo();

  @override
  Widget build(BuildContext context) {
    super.build(context);


    final Widget leading = SizedBox(
      width: kLeadingWidth,
      height: kLineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: kLeadingWidth * 0.3,
            child: Image.asset(
              'assets/img/publish_page/标签icon@hdpi.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '标签',
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

    final Widget buttons = SizedBox(
      height: kLineHeight,
      child: ListView(
        itemExtent: kLineHeight,
        padding: const EdgeInsets.all(0.0),
        physics: const NeverScrollableScrollPhysics(),
        controller:
            PublishPageModel.of(context).pageManager.classificationController,
        children: _buildClassificationType(context),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: buttons,
        ),
      ],
    );
  }

  List<Widget> _buildClassificationType(BuildContext context) {
    return List.generate(
      classificationCount,
      (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _yieldTypes(index).toList(growable: false),
        );
      },
      growable: false,
    );
  }

  Iterable<Widget> _yieldTypes(int classification) sync* {
    final int typeCount = typeCountOf(classification);
    for (int i = 1; i < typeCount; i += 1) {
      yield _TypeButton(
        classification: classification,
        type: i,
      );
      yield const SizedBox(width: 5.0);
    }
  }

  @override
  PublishPageSection get section => PublishPageSection.tag;
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    this.classification,
    this.type,
  });

  final int classification;
  final int type;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: classificationTypeToString(classification, type),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.classificationIndex == classification &&
        model.typeIndex == type;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.handleTypeChange(type);
  }
}
