import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/common/goods.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import '../../widget/special/basic_chip_button.dart';

class Classification extends StatelessWidget {
  const Classification();

  @override
  Widget build(BuildContext context) {
    return ChipButtonLayout(
      builder: (BuildContext context, index) => _ClassificationButton(index),
      itemCount: 6,
      iconPath: 'assets/img/publish_page/分类@hdpi.png',
      title: '分类',
    );
  }
}

class _ClassificationButton extends StatelessWidget {
  const _ClassificationButton(
    this.index,
  );

  final int index;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: classificationToString(index),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.classificationIndex == index;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.handleClassificationChange(index);
    model.pageManager.classificationController.animateTo(
      index * kLineHeight,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
