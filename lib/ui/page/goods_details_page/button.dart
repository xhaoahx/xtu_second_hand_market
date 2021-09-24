import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/ui/widget/common/dim_page_route.dart';
import 'package:xtusecondhandmarket/ui/widget/special/dialog.dart';

import 'goods_details_page.dart' show kTransDuration;
import 'comment.dart' show CommentTextField;

const double _kIconSize = 52.0;

const Color _leftColor = Color(0xFFFCAA40);
const Color _rightColor = Color(0xFFF87913);

class ButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LikeButton(),
              const SizedBox(width: 16.0),
              CommentButton(),
            ],
          ),
        ),
        IWantButton(),
      ],
    );
  }
}

class IWantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = _kIconSize * 0.72;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[_leftColor, _rightColor],
        ),
        borderRadius: BorderRadius.circular(height * 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _leftColor,
            blurRadius: 1.5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context),
          splashColor: _rightColor,
          borderRadius: BorderRadius.circular(height * 0.5),
          child: SizedBox(
            width: 108.0,
            height: height,
            child: Center(
              child: Text(
                '我想要',
                style: TextStyle(
                  fontSize: height * 0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) async {
    final int hour = DateTime.now().hour;
    if (hour > 7 && hour < 23) {
      final bool confirm = await showConfirmDialog(
        context: context,
        leftTitle: '暂不',
        rightTitle: '确认',
        imgUr: 'assets/img/goods_details_page/确认拨打@hdpi.png',
      );
    } else {
      Navigator.of(context).push<void>(
        DimPageRoute<void>(
          builder: (BuildContext context) => _TooLateDialog(),
          defaultPopValue: null,
        ),
      );
    }
  }
}

class CommentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kIconSize,
      height: _kIconSize,
      child: GestureDetector(
        onTap: () {
          _handleOnTap(context);
        },
        child: Image.asset(
          'assets/img/goods_details_page/留言@hdpi.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context) {
    final DetailsPageModel model = DetailsPageModel.of(context);
    if (model.isLoadingPage) {
      return;
    }
    model.showCommentTextField(
      builder: (BuildContext context) => CommentTextField(model.publisher.name),
    );
  }
}

class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _reverse = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: kTransDuration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kIconSize,
      height: _kIconSize,
      child: GestureDetector(
        onTap: _handleOnTap,
        child: CustomPaint(
          painter: _StarIcon(
            controller: _controller,
            bgColor: Theme.of(context).accentColor,
            starColor: const Color(0xFFFF7911),
          ),
        ),
      ),
    );
  }

  void _handleOnTap() {
    final DetailsPageModel model = DetailsPageModel.of(context);
    if (model.isLoadingPage) {
      return;
    }
    if (_reverse) {
      _controller.forward();
      model.showLikeAlert(builder: (BuildContext context) {
        return _LikeAlert();
      });
      // model.addLike
    } else {
      _controller.reverse();
      // model.cancelLike
    }
    _reverse = !_reverse;
  }
}

class _StarIcon extends CustomPainter {
  _StarIcon({
    this.controller,
    this.bgColor,
    this.starColor,
  })  : _colorTween = ColorTween(
          begin: bgColor,
          end: starColor,
        ),
        super(repaint: controller);

  final Color bgColor;
  final Color starColor;
  final AnimationController controller;
  final ColorTween _colorTween;

  @override
  void paint(Canvas canvas, Size size) {
    final bool forward = controller.status == AnimationStatus.forward;
    final double percent = controller.value;

    final double radius = math.min(size.width, size.height) * 0.5;
    canvas.translate(radius, radius);

    final Paint paint = Paint()
      ..color = bgColor
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill
      ..strokeWidth = radius * 0.06;

    Path star;
    if (forward) {
      final outerFactor = percent < 0.6
          ? 1.0 + 0.2 * percent / 0.6
          : 1.2 - 0.2 * (percent - 0.6) / 0.4;
      final innerFactor = percent < 0.7
          ? 1.0 + 0.4 * percent / 0.7
          : 1.4 - 0.4 * (percent - 0.7) / 0.3;
      canvas.drawCircle(Offset.zero, radius * outerFactor, paint);
      paint.color = _colorTween.evaluate(controller);
      star = _drawStar(
        radius * 0.36 * innerFactor,
        radius * 0.7 * innerFactor,
      );
    } else {
      canvas.drawCircle(Offset.zero, radius, paint);
      paint.color = _colorTween.evaluate(controller);
      star = _drawStar(radius * 0.36, radius * 0.7);
    }
    canvas.drawPath(star, paint);
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.white;
    canvas.drawPath(star, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  Path _drawStar(double r1, double r2) {
    assert(r1 < r2);
    final Path path = Path();
    final double base = -54.0 / 180.0 * math.pi;
    final double radians36 = 36.0 / 180.0 * math.pi;
    path.moveTo(0.0, -r2);
    for (int i = 0; i < 5; i += 1) {
      double radians = base + 2 * radians36 * i;
      path.lineTo(
        math.cos(radians) * r1,
        math.sin(radians) * r1,
      );
      radians += radians36;
      path.lineTo(
        math.cos(radians) * r2,
        math.sin(radians) * r2,
      );
    }
    path.close();
    return path;
  }
}

class _TooLateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 280.0,
          maxHeight: 306.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'assets/img/goods_details_page/太晚了点@hdpi.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _LikeAlert extends StatefulWidget {
  @override
  _LikeAlertState createState() => _LikeAlertState();
}

class _LikeAlertState extends State<_LikeAlert>
    with SingleTickerProviderStateMixin<_LikeAlert> {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: kTransDuration);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Tween<Offset> offsetTween = Tween(
      begin: Offset(
        0.0,
        0.13,
      ),
      end: Offset.zero,
    );

    final Widget dialog = Center(
      child: Container(
        width: 100.0,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.black54,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              size: 60.0,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              '收藏成功',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );

    // this widget must be placed directly on overlay
    return Positioned.fill(
      child: SlideTransition(
        position: offsetTween.animate(_controller),
        child: FadeTransition(
          opacity: _controller,
          child: dialog,
        ),
      ),
    );
  }
}
