import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'goods_card.dart';
import '../common/enhanced_nsv.dart';
import '../../../logic/common/tuple.dart';
import '../../../logic/model/theme_model.dart';
import '../../../logic/model/global_goods_model.dart';

export '../../../logic/common/tuple.dart';

const String _loadingText = '加载中...';

typedef OnOverScroll = void Function(BuildContext context);

class BasicGoodsList<T, M extends ChangeNotifier> extends StatelessWidget {
  const BasicGoodsList({
    Key key,
    this.crossAxisCount = 8,
    this.evenIndexCount = 5,
    this.oddIndexCount = 6,
    this.mainAxisSpace = 6.0,
    this.crossAxisSpace = 6.0,
    this.shouldRebuild = _defaultShouldRebuild,
    this.selector,
    @required this.indicator,
    this.useAbsorber = true,
    @required this.keyValue,
    @required this.onOverScroll,
    this.scrollController,
  }) : super(key: key);

  final T keyValue;

  final int crossAxisCount;
  final int oddIndexCount;
  final int evenIndexCount;
  final double mainAxisSpace;
  final double crossAxisSpace;
  final bool useAbsorber;
  final ScrollController scrollController;

  final ShouldRebuild<Tuple2<List<ShortGoodsDetails>, Object>> shouldRebuild;
  final Tuple2<List<ShortGoodsDetails>, Object> Function(
    BuildContext context,
    M model,
  ) selector;
  final OnOverScroll onOverScroll;

  final LoadingIndicator indicator;

  @override
  Widget build(BuildContext context) {
    final sliverChild = Selector<M, Tuple2<List<ShortGoodsDetails>, Object>>(
      builder: (
        BuildContext context,
        Tuple2<List<ShortGoodsDetails>, Object> tuple,
        Widget child,
      ) {
        final int halfCrossAxisCount = crossAxisCount ~/ 2;
        final List<ShortGoodsDetails> selectedList = tuple.valueA;

        return SliverStaggeredGrid.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: selectedList.length,
          itemBuilder: (BuildContext context, int index) {
            final ShortGoodsDetails details = selectedList[index];
            return GoodsCard(details);
          },
          staggeredTileBuilder: (int index) {
            return StaggeredTile.count(
              halfCrossAxisCount,
              index.isOdd ? oddIndexCount : evenIndexCount,
            );
          },
          mainAxisSpacing: mainAxisSpace,
          crossAxisSpacing: crossAxisSpace,
        );
      },
      shouldRebuild: shouldRebuild,
      selector: selector,
    );

    final Widget result = CustomScrollView(
      // we give a small extent,making sure that good card is built after get in screen
      cacheExtent: 60.0,
      controller: scrollController,
      physics: const _HalfClampingScrollPhysics(),
      key: PageStorageKey<T>(keyValue),
      slivers: <Widget>[
        if (useAbsorber)
          SliverOverlapInjector(
            handle: EnhancedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: sliverChild,
        ),
        indicator,
      ],
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: NotificationListener<ScrollUpdateNotification>(
        child: result,
        onNotification: (ScrollUpdateNotification notification) {
          return _onOverScroll(notification, context);
        },
      ),
    );
  }

  static bool _defaultShouldRebuild(
      Tuple2<List<ShortGoodsDetails>, Object> previous,
      Tuple2<List<ShortGoodsDetails>, Object> next) {
    return previous.valueB != next.valueB;
  }

  bool _onOverScroll(
      ScrollUpdateNotification notification, BuildContext context) {
    if (notification.depth != 0) {
      return false;
    }
    final ScrollMetrics metrics = notification.metrics;
    if (metrics.pixels >= metrics.maxScrollExtent) {
      onOverScroll(context);
      return true;
    }
    return false;
  }
}

class LoadingIndicator<M extends ChangeNotifier> extends StatelessWidget {
  const LoadingIndicator({
    Key key,
    this.shouldRebuild = _defaultShouldRebuild,
    this.selector,
  }) : super(key: key);

  final ShouldRebuild<bool> shouldRebuild;
  final bool Function(BuildContext context, M goodsModel) selector;

  @override
  Widget build(BuildContext context) {
    final Widget result = Selector<M, bool>(
      builder: (
        BuildContext context,
        bool isLoading,
        Widget child,
      ) {
        if (isLoading) {
          return SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  _loadingText,
                  style: ThemeModel.of(
                    context,
                  ).fontData.h4_4,
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 0.0,
          );
        }
      },
      selector: selector,
      shouldRebuild: shouldRebuild,
    );

    return SliverToBoxAdapter(
      child: result,
    );
  }

  static bool _defaultShouldRebuild(bool previous, bool next) {
    return previous != next;
  }
}

/// Modified version of ClampingScrollPhysics
class _HalfClampingScrollPhysics extends ScrollPhysics {
  const _HalfClampingScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  _HalfClampingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _HalfClampingScrollPhysics(parent: buildParent(ancestor));
  }

  double frictionFactor(double overscrollFraction) =>
      0.52 * math.pow(1 - overscrollFraction, 2);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) return offset;

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) // underscroll
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) // overscroll
      return 0.0;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge
      return value - position.minScrollExtent;
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return 0.0;
    return 0.0;
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity < 0.0) {
      return ClampingScrollSimulation(
        position: position.pixels,
        velocity: velocity,
        tolerance: tolerance,
      );
    }
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get minFlingVelocity => 100.0;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(
          0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
          40000.0,
        );
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}
