import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../common/publish.dart';
import '../model/publish_page_model.dart';

const Duration _scrollAnimationDuration = Duration(milliseconds: 400);

/// This class is coexists with []
class PublishPageManager {
  PublishPageManager() {
    _pageController = ScrollController();
    _classificationController = ScrollController();
    _onlineWayController = ScrollController();
  }

  ScrollController get pageController => _pageController;
  ScrollController get classificationController => _classificationController;
  ScrollController get onlineWayController => _onlineWayController;

  Future<void> showSection(PublishPageSection section) async {
    print(section);
    if (_isScrolling) {
      return;
    }
    final BuildContext widgetContext = _sectionMapContext[section];
    assert(widgetContext != null);

    final RenderObject contextObject = widgetContext.findRenderObject();
    final RenderAbstractViewport viewport =
        RenderAbstractViewport.of(contextObject);

    assert(viewport != null);
    assert(_pageController.positions.length == 1);
    assert((){
      final RenderObject ro = _pageController.position.context.storageContext.findRenderObject();
      print(ro);
      return true;
    }());

    final double margin = 15.0;

    final double scrollOffset = _pageController.offset;

    final double topOffset = math.max(
      _pageController.position.minScrollExtent,
      viewport.getOffsetToReveal(contextObject, 0.0).offset - margin,
    );

    final double bottomOffset = math.min(
      _pageController.position.maxScrollExtent,
      viewport.getOffsetToReveal(contextObject, 1.0).offset + margin,
    );

    debugPrint(
      'topOffset: $topOffset,bottomOffset: $bottomOffset of $contextObject'
    );

    final bool onScreen =
        scrollOffset <= topOffset && scrollOffset >= bottomOffset;

    // If the context is off screen, then we request a scroll to make it visible.
    if (!onScreen) {
      _isScrolling = true;
      await _pageController.position
          .animateTo(
        scrollOffset < bottomOffset ? bottomOffset : topOffset,
        duration: _scrollAnimationDuration,
        curve: Curves.easeInOut,
      )
          .then((void value) {
        _isScrolling = false;
      });
    }
  }

  void dispose() {
    _pageController.dispose();
    _onlineWayController.dispose();
    _classificationController.dispose();
  }

  /// ## Internal
  ScrollController _pageController;
  ScrollController _classificationController;
  ScrollController _onlineWayController;
  Map<PublishPageSection, BuildContext> _sectionMapContext = {};

  bool _isScrolling = false;

  void _registerSectionContext(
      PublishPageSection section, BuildContext context) {
    assert(section != null);
    assert(context != null);
    _sectionMapContext.remove(section);
    _sectionMapContext[section] = context;
  }
}

abstract class PublishPageRegisterWidget extends StatelessWidget {
  const PublishPageRegisterWidget({Key key}) : super(key: key);

  @protected
  PublishPageSection get section;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    // This print is supposed to called only once,for performance consideration
    print('$section rebuild');

    Provider.of<PublishPageModel>(
      context,
    ).pageManager._registerSectionContext(
          section,
          context,
        );
    return null;
  }
}
