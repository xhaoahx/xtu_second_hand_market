import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:xtusecondhandmarket/logic/common/tuple.dart';
import 'package:xtusecondhandmarket/logic/config/theme_config.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

export 'package:provider/provider.dart';
export 'package:xtusecondhandmarket/logic/common/tuple.dart';
export 'package:xtusecondhandmarket/logic/model/global_user_model.dart';

typedef TypeItemBuilder<T> = Widget Function(BuildContext context, T item);

const double _kHeaderHeight = 100.0;
const String _kLoadingText = '加载中...';
const Color _kBgColor = Color(0xFFFAFAFA);

class ProfilePageBasicLayout<M extends ChangeNotifier, T>
    extends StatefulWidget {
  const ProfilePageBasicLayout({
    @required this.itemBuilder,
    @required this.emptyStatusBuilder,
    @required this.title,
    @required this.headerTitle,
    @required this.headerSubTitle,
    @required this.selector,
    @required this.indicatorSelector,
    @required this.firstTimeLoadingCallback,
  });

  final String title;
  final String headerTitle;
  final String headerSubTitle;
  final TypeItemBuilder<T> itemBuilder;
  final WidgetBuilder emptyStatusBuilder;
  final Tuple2<List<T>, Object> Function(BuildContext context, M model)
      selector;
  final bool Function(BuildContext context, M model) indicatorSelector;
  final void Function(BuildContext context) firstTimeLoadingCallback;

  @override
  _ProfilePageBasicLayoutState<M, T> createState() =>
      _ProfilePageBasicLayoutState<M, T>();
}

class _ProfilePageBasicLayoutState<M extends ChangeNotifier, T>
    extends State<ProfilePageBasicLayout<M, T>> {
  @override
  void initState() {
    super.initState();
    _firstTimeLoading();
  }

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final User user = GlobalUserModel.of(context).user;

    final Widget appBar = Container(
      color: Colors.white,
      height: 86.0,
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: Navigator.of(context).pop,
            ),
            Text(
              widget.title,
              style: fontData.h3_1,
            )
          ],
        ),
      ),
    );

    final ValueKey<String> headerKey = ValueKey('header');

    final Widget header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      height: _kHeaderHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_kHeaderHeight * 0.5),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 2.4,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 120.0,
                      child: Text(
                        user.name,
                        style: fontData.h4_4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.headerTitle,
                        style: fontData.h4_4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 7.0),
                Text(
                  widget.headerSubTitle,
                  style: fontData.h5_2,
                )
              ],
            ),
          ),
          SizedBox(
            width: _kHeaderHeight * 0.5,
            height: _kHeaderHeight * 0.5,
            child: CachedNetworkImage(
              imageUrl: user.avatarUrl,
              imageBuilder:
                  (BuildContext context, ImageProvider<dynamic> image) {
                return CircleAvatar(
                  radius: _kHeaderHeight * 0.25,
                  backgroundImage: image,
                );
              },
            ),
          )
        ],
      ),
    );

    final Widget listView = Selector<M, Tuple2<List<T>, Object>>(
      selector: widget.selector,
      builder: (
        BuildContext context,
        Tuple2<List<T>, Object> tuple,
        Widget child,
      ) {
        final List<T> itemList = tuple.valueA;
        final Object hasChanged = tuple.valueB;

        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(key: headerKey,child: header),
            if (itemList.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, index) {
                    return widget.itemBuilder(context, itemList[index]);
                  },
                  childCount: itemList.length,
                ),
              ),
            if (itemList.isEmpty && hasChanged != null)
              SliverFillRemaining(
                fillOverscroll: false,
                child: Builder(
                  builder: widget.emptyStatusBuilder,
                ),
              ),
            _LoadingIndicator(selector: widget.indicatorSelector),
          ],
        );
      },
      shouldRebuild:
          (Tuple2<List<T>, Object> previous, Tuple2<List<T>, Object> next) {
        return previous.valueB != next.valueB;
      },
    );

    return Material(
      color: _kBgColor,
      child: Column(
        children: <Widget>[
          appBar,
          Expanded(
            child: listView,
          )
        ],
      ),
    );
  }

  void _firstTimeLoading() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.firstTimeLoadingCallback(context);
    });
  }
}

class _LoadingIndicator<M extends ChangeNotifier> extends StatelessWidget {
  const _LoadingIndicator({
    Key key,
    this.selector,
  }) : super(key: key);

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
                  _kLoadingText,
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
    );

    return SliverToBoxAdapter(
      child: result,
    );
  }
}
