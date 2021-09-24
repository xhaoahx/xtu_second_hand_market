import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

const double kLineHeight = 26.0;
const Duration kTransDuration = Duration(milliseconds: 300);
const Color _kSelectedColor = Color(0xFFFEEAB5);
const double kTextFontSize = 13.0;
const double kLeadingWidth = 74.0;

class ChipButtonLayout extends StatelessWidget {
  const ChipButtonLayout({
    @required this.title,
    @required this.itemCount,
    @required this.builder,
    @required this.iconPath,
  });

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder builder;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
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
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
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
      height: kLineHeight * 2 + 12.0,
      child: Wrap(
        children: List<Widget>.generate(
          itemCount,
          (index) => builder(context, index),
        ),
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.spaceEvenly,
        direction: Axis.horizontal,
        runSpacing: 6.0,
        spacing: 10.0,
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
}

class BasicChipButton<T extends ChangeNotifier> extends StatelessWidget {
  const BasicChipButton({
    @required this.selector,
    @required this.title,
    @required this.onTap,
  });

  final String title;
  final VoidCallback onTap;
  final bool Function(BuildContext context, T model) selector;

  @override
  Widget build(BuildContext context) {
    final Widget result = Selector<T, bool>(
      selector: selector,
      shouldRebuild: shouldRebuild,
      builder: (BuildContext context, bool isSelected, Widget child) {
        return AnimatedContainer(
          height: kLineHeight,
          duration: kTransDuration,
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 2.0,
          ),
          decoration: BoxDecoration(
            color: isSelected ? _kSelectedColor : Colors.white,
            border: Border.all(color: _kSelectedColor, width: 0.8),
            borderRadius: BorderRadius.circular(kLineHeight * 0.5),
          ),
          child: child,
        );
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: ThemeModel.of(context).fontData.h4_1.copyWith(
              fontSize: kTextFontSize,
              textBaseline: TextBaseline.alphabetic,
            ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: result,
    );
  }

  bool shouldRebuild(bool previous, bool next) {
    return previous != next;
  }
}
