import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

const Duration _kScrollDuration = Duration(milliseconds: 100);
const double _kAppbarHeight = 86.0;

class DetailsAppBar extends StatelessWidget {
  DetailsAppBar();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = DetailsPageModel.of(context).scrollController;
    final Widget appbar = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        return DetailsAppBarContent(
          scrollController: scrollController,
          isLoading: isLoading,
        );
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    return Container(
      height: _kAppbarHeight,
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: Navigator.of(context).pop,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: appbar,
              ),
            )
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
    );
  }
}

class DetailsAppBarContent extends StatefulWidget {
  const DetailsAppBarContent({
    this.scrollController,
    this.isLoading,
  });

  final ScrollController scrollController;
  final isLoading;

  @override
  _DetailsAppBarContentState createState() => _DetailsAppBarContentState();
}

class _DetailsAppBarContentState extends State<DetailsAppBarContent> {
  PageController _pageController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(DetailsAppBarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.scrollController.removeListener(_pageListener);
    _scrollController = widget.scrollController;
    assert(_scrollController.hasClients);
    _scrollController.addListener(_pageListener);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _pageListener();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_pageListener);
    super.dispose();
  }

  void _pageListener() {
    if (mounted && _pageController.hasClients) {
      // 64 + 320 + 80 = 464
      final double pixels = _scrollController.position.pixels;

      if (pixels > 464.0) {
        _pageController.animateToPage(
          1,
          duration: _kScrollDuration,
          curve: Curves.decelerate,
        );
      } else if (pixels < 400.0) {
        _pageController.animateToPage(
          0,
          duration: _kScrollDuration,
          curve: Curves.decelerate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final FontData fontData = ThemeModel.of(context).fontData;
    final Widget pageTitle = Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '商品详情',
        style: fontData.h3_1,
      ),
    );

    if (widget.isLoading) {
      return pageTitle;
    } else {
      final DetailsPageModel model = DetailsPageModel.of(context);
      final FullGoodsDetails details = model.fullDetails;
      final Widget goodInfo = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Text(
              details.title,
              style: fontData.h3_1,
            ),
          ),
          CachedNetworkImage(
            imageUrl: model.publisher.avatarUrl,
            imageBuilder: (
              BuildContext context,
              ImageProvider imageProvide,
            ) {
              return Container(
                width: _kAppbarHeight * 0.5,
                height: _kAppbarHeight * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvide,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      );

      return PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          pageTitle,
          goodInfo,
        ],
      );
    }
  }
}
