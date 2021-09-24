import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/common/contact.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import '../../widget/special/basic_chip_button.dart';

class GradeInfo extends StatelessWidget {
  const GradeInfo();

  @override
  Widget build(BuildContext context) {
    return ChipButtonLayout(
      builder: (BuildContext context,index) => _GradeButton(index),
      itemCount: 7,
      iconPath: 'assets/img/publish_page/年级@hdpi.png',
      title: '年级',
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton(
    this.index,
  );

  final int index;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: gradeToString(index),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.gradeIndex == index;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.handleGradeChange(index);
  }
}
