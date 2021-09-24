import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

const double _kHeight = 32.0;

class AlertSnakeBar extends StatefulWidget {
  const AlertSnakeBar({
    Key key,
    this.inDuration = const Duration(milliseconds: 300),
    this.outDuration = const Duration(milliseconds: 300),
    this.hoverDuration = const Duration(milliseconds: 1500),
    this.text,
    this.queued = false,
    this.onEnd,
  }) : super(key: key);

  final String text;
  final Duration inDuration;
  final Duration hoverDuration;
  final Duration outDuration;
  final bool queued;
  final VoidCallback onEnd;

  @override
  _AlertSnakeBarState createState() => _AlertSnakeBarState();
}

class _AlertSnakeBarState extends State<AlertSnakeBar>
    with TickerProviderStateMixin<AlertSnakeBar> {
  AnimationController _inController;
  AnimationController _outController;

  static final Queue<VoidCallback> _buildQueue = Queue();

  @override
  void initState() {
    super.initState();
    _inController = AnimationController(
      vsync: this,
      duration: widget.inDuration,
    );
    _outController = AnimationController(
      vsync: this,
      duration: widget.outDuration,
    )..addStatusListener(_endListener);

    if (widget.queued) {
      _buildQueue.add(_enterStage);
      if (_buildQueue.isEmpty) {
        Future.delayed(Duration.zero,_toggleNext);
      }
    } else {
      _enterStage();
    }
  }

  @override
  void dispose() {
    _inController.dispose();
    _outController.dispose();
    super.dispose();
  }

  void _endListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onEnd?.call();
      _toggleNext();
    }
  }

  Future<void> _enterStage() async {
    await _inController.forward();
    await Future.delayed(widget.hoverDuration);
    _leaveStage();
  }

  void _leaveStage() {
    _inController.reverse();
    _outController.forward();
  }

  void _toggleNext() {
    if (_buildQueue.isNotEmpty) {
      _buildQueue.removeFirst().call();
    }
  }

  static final Tween<Offset> _positionTween = Tween(
    begin: Offset(0.0, -1.0),
    end: Offset.zero,
  );

  static final Tween<double> _opacityTween = Tween(begin: 1.0, end: 0.0);

  @override
  Widget build(BuildContext context) {
    final Widget content = SlideTransition(
      position: _positionTween.animate(_inController),
      child: FadeTransition(
        opacity: _opacityTween.animate(_outController),
        child: Container(
          color: Theme.of(context).accentColor,
          child: Center(
            child: Text(
              widget.text,
              style: ThemeModel.of(
                context,
              ).fontData.h4_1.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // A super overlay widget is required
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 0.0,
      height: _kHeight,
      child: content,
    );
  }
}
