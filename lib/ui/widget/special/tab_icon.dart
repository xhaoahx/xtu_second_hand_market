import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketIcon extends CustomPainter {
  MarketIcon({
    @required this.animation,
    @required this.bgColor,
    @required this.mainColor,
  }) : super(repaint: animation);

  final Animation animation;
  final Color bgColor;
  final Color mainColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min<double>(size.width, size.height) * 0.5;
    final AnimationStatus status = animation.status;

    Paint paint = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.15
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;

    canvas.translate(radius, radius);

    final double percent = animation.value;
    if(status == AnimationStatus.forward){
      final double factor =
      percent < 0.7 ? percent * 0.2857 + 1.0 : 1.2 - (percent - 0.7) * 0.66;
      canvas.scale(factor);
    }

    canvas.drawPath(_paintBounds(radius), paint);
    canvas.drawPath(_drawRightDoor(radius), paint);
    canvas.drawPath(_drawLeftDoor(radius), paint);

    paint..color = mainColor;
    canvas.drawPath(_paintSun(radius), paint);

    if (percent != 0) {
      canvas.drawPath(
        _paintBounds(
          radius,
          percent,
        ),
        paint,
      );
      canvas.drawPath(
          _drawRightDoor(
            radius,
            percent,
          ),
          paint);
      canvas.drawPath(
          _drawLeftDoor(
            radius,
            percent,
          ),
          paint);
      paint
        ..color = mainColor.withAlpha(90)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(
          radius * 0.25,
          radius * 0.15,
        ),
        radius * 0.9 * percent,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(MarketIcon oldDelegate) => false;

  Path _paintBounds(double radius, [double percent = 1.0]) {
    Path path = Path();
    path.arcTo(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 2,
        height: radius * 2,
      ),
      -0.5235,
      5.75958 * percent,
      true,
    );
    return path;
  }

  Path _paintSun(double radius) {
    Path path = Path();
    final r = radius * 0.56;
    path.arcTo(
      Rect.fromCenter(
        center: Offset(0.0, -r),
        width: r,
        height: r,
      ),
      0.0,
      math.pi,
      true,
    );
    return path;
  }

  Path _drawRightDoor(double radius, [double percent = 1.0]) {
    Path path = Path();
    if (percent > 0) {
      final double p = percent.clamp(0.0, 0.7) / 0.7;
      path.moveTo(
        radius * 0.35,
        radius * 0.93,
      );
      path.lineTo(
        radius * (0.35 - 0.12 * p),
        radius * (0.93 - p * 0.63),
      );
    }
    if (percent > 0.7) {
      percent = (percent - 0.7) / 0.3;
      path.lineTo(
        radius * (0.23 - percent * 0.15),
        radius * (0.3 - percent * 0.2),
      );
    }

    return path;
  }

  Path _drawLeftDoor(double radius, [double percent = 1.0]) {
    Path path = Path();
    if (percent > 0) {
      final double p = percent.clamp(0.0, 0.7) / 0.7;
      path.moveTo(
        -radius * 0.35,
        radius * 0.93,
      );
      path.lineTo(
        radius * (0.12 * p - 0.35),
        radius * (0.93 - p * 0.63),
      );
    }
    if (percent > 0.7) {
      percent = (percent - 0.7) / 0.3;
      path.lineTo(
        radius * (percent * 0.15 - 0.23),
        radius * (0.3 - percent * 0.2),
      );
    }

    return path;
  }
}

class PublishIcon extends CustomPainter {
  PublishIcon({
    @required this.animation,
    @required this.bgColor,
    @required this.mainColor,
  }) : super(repaint: animation);

  final Animation animation;
  final Color bgColor;
  final Color mainColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min<double>(size.width, size.height) * 0.5;
    final AnimationStatus status = animation.status;

    Paint paint = Paint()
      ..color = mainColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.15
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.bevel;

    canvas.translate(radius, radius);

    final double percent = animation.value;
    final double factor =
    percent < 0.7 ? percent * 0.2857 + 1.0 : 1.2 - (percent - 0.7) * 0.66;
    if(status == AnimationStatus.forward){
      canvas.scale(factor);
    }

    canvas.drawCircle(Offset.zero, radius, paint);
    canvas.drawCircle(
        Offset.zero, radius * 1.08, paint..color = mainColor.withAlpha(50));

    canvas.rotate(factor * 1.571 * percent);
    final length = radius * 0.6;
    paint.color = Colors.white;

    canvas.drawLine(Offset(-length, 0.0), Offset(length, 0.0), paint);
    canvas.drawLine(Offset(0.0, -length), Offset(0.0, length), paint);
  }

  @override
  bool shouldRepaint(PublishIcon oldDelegate) => false;
}

class ProfileIcon extends CustomPainter {
  const ProfileIcon({
    @required this.animation,
    @required this.bgColor,
    @required this.mainColor,
  }) : super(repaint: animation);

  final Animation animation;
  final Color bgColor;
  final Color mainColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min<double>(size.width, size.height) * 0.5;
    final AnimationStatus status = animation.status;

    Paint paint = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.15
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;

    canvas.translate(radius, radius);

    final double percent = animation.value;
    if(status == AnimationStatus.forward){
      final double factor =
      percent < 0.7 ? percent * 0.2857 + 1.0 : 1.2 - (percent - 0.7) * 0.66;
      canvas.scale(factor);
    }

    final double radians = 24 / 180 * math.pi;

    canvas.save();
    canvas.translate(0.0, radius);
    paint.color = bgColor;
    canvas.drawPath(_paintBody(radius * 0.85, radians), paint);
    paint..color = mainColor;
    canvas.drawPath(_paintBody(radius * 0.85, radians, percent), paint);
    canvas.restore();

    final double r = radius * 0.4;
    paint..color = mainColor;
    canvas.drawCircle(
      Offset(0.0, -radius * 0.5),
      r,
      paint,
    );

    paint.color = mainColor.withAlpha(90);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
        radius * 0.25,
        radius * 0.15,
      ),
      radius * 0.9 * percent,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProfileIcon oldDelegate) => false;

  Path _paintBody(double radius, double radians, [double percent = 1.0]) {
    final dx = math.cos(radians) * radius / (math.sin(radians) + 1);
    final dy = math.tan(radians) * dx;

    Path path = Path();
    if (percent > 0.0) {
      final p = percent.clamp(0.0, 0.4) * 2.5; // 0.4
      path.moveTo(dx, 0.0);
      path.lineTo(dx * (1.0 - p * 2), 0.0);
    }
    if (percent > 0.4) {
      final p = (percent.clamp(0.4, 0.5) - 0.4) * 10; // 0.1
      path.arcTo(
        Rect.fromCenter(
          center: Offset(-dx, -dy),
          width: dy * 2,
          height: dy * 2,
        ),
        1.5701,
        (1.570 + radians) * p,
        true,
      );
    }
    if (percent > 0.5) {
      final p = (percent - 0.5) * 2;
      path.arcTo(
        Rect.fromCenter(
          center: Offset.zero,
          width: 2 * radius,
          height: 2 * radius,
        ),
        math.pi + radians,
        (math.pi - radians * 2) * p,
        true,
      );
    }
    return path;
  }
}
