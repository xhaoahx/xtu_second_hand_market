import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:xtusecondhandmarket/logic/common/goods.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../widget/special/basic_chip_button.dart';

const Duration _kTransDuration = Duration(milliseconds: 400);
const double _kTextFieldHeight = 40.0;

class OnlineInfo extends PublishPageRegisterWidget {
  const OnlineInfo();

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              'assets/img/publish_page/线上联系方式@hdpi.png',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '线上联系',
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
      child: Row(
        children: <Widget>[
          _OnlineInfoButton(0),
          const SizedBox(width: 15.0),
          _OnlineInfoButton(1),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: Column(
            children: <Widget>[
              buttons,
              _AlertWidget(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  PublishPageSection get section => PublishPageSection.onlineWay;
}

class _AlertWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PublishPageModel, bool>(
      builder: (BuildContext context, bool shouldShow, Widget child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            child: _AnimatedAlign(
              heightFactor: shouldShow ? 1.0 : 0.0,
              child: child,
              duration: _kTransDuration,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 3.0,
          ),
          Text(
            '*请选择常用软件进行填写',
            style: ThemeModel.of(context)
                .fontData
                .h5_1
                .copyWith(color: Colors.grey),
          ),
        ],
      ),
      selector: (BuildContext context, PublishPageModel model) {
        return model.onlineWayIndex == -1;
      },
    );
  }
}

class _OnlineInfoButton extends StatelessWidget {
  const _OnlineInfoButton(this.onlineWay);

  final int onlineWay;

  @override
  Widget build(BuildContext context) {
    return BasicChipButton<PublishPageModel>(
      selector: _selector,
      title: onlineWayToString(onlineWay),
      onTap: () {
        _handleOnTap(context);
      },
    );
  }

  bool _selector(BuildContext context, PublishPageModel model) {
    return model.onlineWayIndex == onlineWay;
  }

  void _handleOnTap(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    model.pageManager.onlineWayController.animateTo(
      (onlineWay + 1) * _kTextFieldHeight,
      duration: _kTransDuration,
      curve: Curves.linear,
    );
    model.handleOnlineWayChange(onlineWay);
  }
}

abstract class _TextFieldLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PublishPageModel model = PublishPageModel.of(context);
    final ThemeData themeData = Theme.of(context);

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
              _iconPath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _title,
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
      height: _kTextFieldHeight,
      child: TextField(
        focusNode: model.focusNodeManager.focusNodeOf(_section),
        controller: model.focusNodeManager.controllerOf(_section),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请填写$_title号码',
        ),
        textInputAction: TextInputAction.done,
        cursorColor: themeData.primaryColor,
        onChanged: (String newValue) => handleContentChange(model, newValue),
        autofocus: false,
        inputFormatters: [
          LengthLimitingTextInputFormatter(11),
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        Expanded(
          child: Baseline(
            baseline: kLineHeight,
            baselineType: TextBaseline.alphabetic,
            child: textField,
          ),
        ),
      ],
    );
  }

  void handleContentChange(PublishPageModel model, String newValue);
  String get _iconPath;
  String get _title;
  PublishPageSection get _section;
}

class QQTextField extends _TextFieldLayout {
  @override
  void handleContentChange(PublishPageModel model, String newValue) {
    return model.handleQQNumChange(newValue);
  }

  @override
  String get _iconPath => 'assets/img/publish_page/QQ@hdpi.png';


  @override
  String get _title => 'QQ';

  @override
  // TODO: implement section
  PublishPageSection get _section => PublishPageSection.qqNum;
}

class WXTextField extends _TextFieldLayout {
  @override
  void handleContentChange(PublishPageModel model, String newValue) {
    return model.handleWXNumChange(newValue);
  }

  @override
  String get _iconPath => 'assets/img/publish_page/微信@hdpi.png';

  @override
  String get _title => '微信';

  @override
  PublishPageSection get _section => PublishPageSection.wxNum;
}

class OnlineTextFields extends PublishPageRegisterWidget {
  const OnlineTextFields();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: _kTextFieldHeight,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        controller:
            PublishPageModel.of(context).pageManager.onlineWayController,
        children: <Widget>[
          const SizedBox(),
          QQTextField(),
          WXTextField(),
        ],
        itemExtent: _kTextFieldHeight,
        padding: const EdgeInsets.all(0.0),
      ),
    );
  }

  @override
  PublishPageSection get section => PublishPageSection.onlineNum;
}

class _AnimatedAlign extends ImplicitlyAnimatedWidget {
  _AnimatedAlign({
    Key key,
    this.alignment = Alignment.center,
    this.heightFactor = 1.0,
    this.widthFactor = 1.0,
    @required this.child,
    @required Duration duration,
    Curve curve = Curves.linear,
    VoidCallback onEnd,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        );

  final Widget child;
  final double heightFactor;
  final double widthFactor;
  final AlignmentGeometry alignment;
  @override
  _AnimatedAlignState createState() => _AnimatedAlignState();
}

class _AnimatedAlignState extends AnimatedWidgetBaseState<_AnimatedAlign> {
  AlignmentGeometryTween _alignmentTween;
  Tween<double> _widthFactorTween;
  Tween<double> _heightFactorTween;
  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: _heightFactorTween.evaluate(animation),
      widthFactor: _widthFactorTween.evaluate(animation),
      alignment: _alignmentTween.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignmentTween = visitor(
      _alignmentTween,
      widget.alignment,
      (dynamic value) => AlignmentGeometryTween(
        begin: value as AlignmentGeometry,
      ),
    ) as AlignmentGeometryTween;
    _widthFactorTween = visitor(
      _widthFactorTween,
      widget.widthFactor,
      (dynamic value) => Tween<double>(
        begin: value as double,
      ),
    ) as Tween<double>;
    _heightFactorTween = visitor(
      _heightFactorTween,
      widget.heightFactor,
      (dynamic value) => Tween<double>(
        begin: value as double,
      ),
    ) as Tween<double>;
  }
}
