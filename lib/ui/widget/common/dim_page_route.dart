import 'dart:ui';

import 'package:flutter/material.dart';

const _kTransDuration = const Duration(milliseconds: 500);

class DimPageRoute<T> extends PageRoute<T> {
  DimPageRoute({
    @required this.builder,
    this.transitionDuration = _kTransDuration,
    @required this.defaultPopValue,
  }) : assert(builder != null);

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  final T defaultPopValue;

  @override
  Color get barrierColor => null;

  @override
  bool get opaque => false;

  @override
  String get barrierLabel => 'DimPageRoute';

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    print('build page');
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Tween<Offset> offsetTween = Tween(
      begin: Offset(
        0.0,
        0.13,
      ),
      end: Offset.zero,
    );

    final Widget dim = Positioned.fill(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 6.0 * animation.value,
              sigmaY: 6.0 * animation.value,
            ),
            child: child,
          );
        },
        child: GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
          onTap: (){
            Navigator.of(context).pop<T>(defaultPopValue);
          },
        ),
      ),
    );

    final Animation<double> dialogAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        0.4,
        0.85,
      ),
    );

    final Widget dialog = SlideTransition(
      position: offsetTween.animate(dialogAnimation),
      child: FadeTransition(
        opacity: dialogAnimation,
        child: child,
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[dim, dialog],
    );
  }
}
