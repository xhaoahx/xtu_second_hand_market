import 'package:flutter/material.dart';

const double _kVerticalPadding = 3.0;

class DecoratedText extends LeafRenderObjectWidget {
  const DecoratedText(
    this.textSpan, {
    this.backgroundColor,
    this.factor = 0.6,
  })  : assert(textSpan != null),
        assert(factor != null);

  final TextSpan textSpan;
  final Color backgroundColor;
  final double factor;

  @override
  RenderDecoratedText createRenderObject(BuildContext context,) {
    final Color bgColor= backgroundColor ?? Theme.of(context).primaryColor;

    return RenderDecoratedText()
      ..textSpan = textSpan
      ..backgroundColor = bgColor
      ..factor = factor;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderDecoratedText renderObject,) {
    final Color bgColor= backgroundColor ?? Theme.of(context).primaryColor;

    renderObject
      ..textSpan = textSpan
      ..backgroundColor = bgColor
      ..factor = factor;
  }
}

class RenderDecoratedText extends RenderBox {
  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    textScaleFactor: 1.0,
  );

  double _factor;
  set factor(double value) {
    if (value == _factor) return;
    _factor = value;
    markNeedsPaint();
  }

  TextSpan _textSpan;
  set textSpan(TextSpan value) {
    if (value == _textSpan) return;
    _textSpan = value;
    _textPainter..text = _textSpan;
    markNeedsLayout();
  }

  Color _backgroundColor;
  set backgroundColor(Color value) {
    if (value == _backgroundColor) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);
    size = constraints.constrain(_textPainter.size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    Paint paint = Paint()..color = _backgroundColor;

    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + _textPainter.height * _factor,
        size.width + _kVerticalPadding * 2.0,
        _textPainter.height * 0.5,
      ),
      paint,
    );
    _textPainter.paint(
      canvas,
      Offset(
        offset.dx + _kVerticalPadding,
        offset.dy,
      ),
    );
  }
}
