import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/search_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/widget/common/decorated_text.dart';

const double _kOverlayHeight = 180.0;

class HistoryOverlay extends StatelessWidget {
  const HistoryOverlay();

  @override
  Widget build(BuildContext context) {
    final SearchPageModel model = SearchPageModel.of(context);

    final Widget list = Selector<SearchPageModel, bool>(
      builder: (BuildContext context, bool isLoadingHistory, Widget child) {
        return isLoadingHistory
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  final String content = model.searchHistory[index];
                  return ListTile(
                    title: Text(
                      content,
                    ),
                    onTap: () => model.handleSearchHistory(content),
                  );
                },
                itemCount: model.searchHistory.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
      },
      selector: (BuildContext context, SearchPageModel model) {
        return model.isLoadingHistory;
      },
    );

    return Selector<SearchPageModel, bool>(
      builder: (BuildContext context, bool shouldShow, Widget child) {
        print('build HistoryOverlayImpl with $shouldShow');
        return Align(
          alignment: Alignment.topCenter,
          child: HistoryOverlayImpl(
            expanded: shouldShow,
            child: child,
          ),
        );
      },
      selector: (BuildContext context, SearchPageModel model) {
        return model.isEditing;
      },
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 2.0,
                offset: Offset(0.0, 1.0),
              ),
            ],
            color: Colors.white,
          ),
          height: _kOverlayHeight,
          margin: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 5.0,
          ),
          child: list),
    );
  }
}

class HistoryOverlayImpl extends ImplicitlyAnimatedWidget {
  const HistoryOverlayImpl({
    this.expanded = false,
    this.child,
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback onEnd,
  }) : super(duration: duration, curve: curve, onEnd: onEnd);

  final bool expanded;
  final Widget child;

  @override
  _HistoryOverlayState createState() => _HistoryOverlayState();
}

class _HistoryOverlayState extends AnimatedWidgetBaseState<HistoryOverlayImpl> {
  Tween<double> _valueTween;

  @override
  Widget build(BuildContext context) {
    final double value = _valueTween.evaluate(animation);

    return Opacity(
      opacity: value,
      child: ClipRect(
        child: Align(
          heightFactor: value,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    final double _targetValue = widget.expanded ? 1.0 : 0.0;
    _valueTween = visitor(_valueTween, _targetValue,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>;
  }
}
