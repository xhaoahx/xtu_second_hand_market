import 'dart:collection';

import 'package:flutter/material.dart';

typedef AnimationBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

const Duration _kTranDuration = Duration(milliseconds: 500);

class AnimatedSliverWrapper extends StatefulWidget {
  const AnimatedSliverWrapper({
    Key key,
    @required this.typeKey,
    @required this.builder,
    this.queued = true,
    this.enable = true,
    this.forwardBuilder = _defaultAnimationBuilder,
    this.reverseBuilder = _defaultAnimationBuilder,
    this.forwardCurve = Curves.linear,
    this.reverseCurve = Curves.linear,
    this.forwardDuration = _kTranDuration,
    this.reverseDuration = _kTranDuration,
    this.factor = 0.75,
  })  : assert(forwardBuilder != null),
        assert(queued != null),
        assert(builder != null),
        assert(queued && factor != null),
        super(key: key);

  final WidgetBuilder builder;
  final bool queued;
  final bool enable;

  final Curve forwardCurve;
  final Curve reverseCurve;
  final Duration forwardDuration;
  final Duration reverseDuration;
  final AnimationBuilder forwardBuilder;
  final AnimationBuilder reverseBuilder;

  final double factor;

  /// The typeKey is used to identify type of wrapped widget,
  /// it must implement [operator ==]
  final Object typeKey;

  @override
  AnimatedSliverWrapperState createState() {
    AnimatedSliverWrapperState._buildQueueMap[typeKey] ??= Queue();
    return AnimatedSliverWrapperState();
  }

  static Widget _defaultAnimationBuilder(
    BuildContext context,
    Animation animation,
    Widget child,
  ) {
    final Tween<Offset> positionTween = Tween(
      begin: Offset(0.0, 2.0),
      end: Offset.zero,
    );
    return SlideTransition(
      position: positionTween.animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static AnimatedSliverWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedSliverWrapperState>();
  }
}

class AnimatedSliverWrapperState extends State<AnimatedSliverWrapper>
    with SingleTickerProviderStateMixin<AnimatedSliverWrapper> {
  static final Map<Object, Queue<VoidCallback>> _buildQueueMap = {};

  AnimationController _controller;
  Widget _builtChild;
  bool _isForward = true;

  @override
  void initState() {
    print('initState');
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.forwardDuration);
    _builtChild = Builder(
      builder: widget.builder,
    );

    final Queue<VoidCallback> typeQueue = _buildQueueMap[widget.typeKey];

    if (widget.queued) {
      if (typeQueue.isEmpty) {
        Future.delayed(Duration.zero, _toggleNext);
      }
      print('add To queue ${widget.typeKey}');
      typeQueue.add(_startAnimation);
    } else {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    print('start animation');
    if (mounted) {
      if (widget.enable) {
        _controller.forward();
      } else {
        _controller.value = 1.0;
      }
    }
    assert(widget.factor != null);
    Future<void>.delayed(widget.forwardDuration * widget.factor, _toggleNext);
  }

  void _toggleNext() {
    final Queue<VoidCallback> typeQueue = _buildQueueMap[widget.typeKey];

    if (typeQueue.isNotEmpty) {
      typeQueue.removeFirst().call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: _controller,
      curve: _isForward ? widget.forwardCurve : widget.reverseCurve,
    );
    return _isForward
        ? widget.forwardBuilder(context, animation, _builtChild)
        : widget.reverseBuilder(context, animation, _builtChild);
  }

  TickerFuture reverse() {
    setState(() {
      _isForward = false;
      _controller.duration = widget.reverseDuration;
    });
    return _controller.reverse();
  }
}
