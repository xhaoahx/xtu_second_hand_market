import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/common/contact.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import '../../widget/special/basic_chip_button.dart';

class DormitoryInfo extends StatelessWidget {
  const DormitoryInfo();

  @override
  Widget build(BuildContext context) {
    return ChipButtonLayout(
      builder: (BuildContext context,index) => _DormitoryButton(index),
      itemCount: 6,
      iconPath: 'assets/img/publish_page/宿舍@hdpi.png',
      title: '宿舍',
    );
  }
}

class _DormitoryButton extends StatelessWidget {
  const _DormitoryButton(
      this.index,
      );

  final int index;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: dormitoryToString(index),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.dormitoryIndex == index;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.handleDormitoryChange(index);
  }
}
