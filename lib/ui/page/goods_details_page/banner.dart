import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/ui/page/picture_display_page/picture_display_page.dart';

import 'goods_details_page.dart' show kTransDuration, kBannerHeight;

const Duration _kNextPageDuration = Duration(milliseconds: 4500);

class DetailsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget page = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        return BannerContent(isLoading);
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    final Widget decoration = ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: page,
      ),
    );

    return SizedBox(
      height: kBannerHeight,
      child: decoration,
    );
  }
}

class BannerContent extends StatefulWidget {
  BannerContent(this.isLoading);

  final bool isLoading;

  @override
  _BannerContentState createState() => _BannerContentState();
}

class _BannerContentState extends State<BannerContent> {
  Timer _timer;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cancelTimer();
    super.dispose();
  }

  @override
  void didUpdateWidget(BannerContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cancelTimer();
    _createTimer();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      child: widget.isLoading
          ? const CircularProgressIndicator()
          : _buildPageView(context),
      duration: kTransDuration,
    );
  }

  Widget _buildPageView(BuildContext context){
    final FullGoodsDetails details = DetailsPageModel.of(context).fullDetails;
    final int listLength = details.imgUrls.length;

    final Widget pageView = PageView.builder(
      controller: _pageController,
      itemCount: listLength,
      itemBuilder: (BuildContext context, int index) {
        final Widget image = Align(
          alignment: Alignment.topCenter,
          heightFactor: 1.0,
          widthFactor: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: kBannerHeight,
              child: Hero(
                tag: 'image$index',
                child: CachedNetworkImage(
                  imageUrl: details.imgUrls[index],
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context,String url){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ),
          ),
        );

        return GestureDetector(
          onTap: () {
            _handleOnTap(index);
          },
          child: image,
        );
      },
    );

    final Widget pageIndicator = _PageIndicator(_pageController, listLength);

    return Stack(
      children: <Widget>[
        Positioned.fill(child: pageView),
        Positioned(
          left: 40.0,
          right: 40.0,
          bottom: 40.0,
          height: 15.0,
          child: pageIndicator,
        )
      ],
    );
  }

  void _handleToNextPage(Timer timer) {
    if(_pageController.position.activity.isScrolling){
      return;
    }
    final FullGoodsDetails details = DetailsPageModel.of(context).fullDetails;
    final int maxPage = details.imgUrls.length - 1;
    if (_pageController.page.toInt() == maxPage) {
      _pageController.animateToPage(0, duration: kTransDuration, curve: Curves.linear);
    }else{
      _pageController.nextPage(
        duration: kTransDuration,
        curve: Curves.linear,
      );
    }
  }

  void _createTimer(){
    if (!widget.isLoading) {
      _timer = Timer.periodic(
        _kNextPageDuration,
        _handleToNextPage,
      );
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleOnTap(int index) {
    final FullGoodsDetails details = DetailsPageModel.of(context).fullDetails;

    Navigator.of(context).pushNamed(
      PictureDisplayPage.routeName,
      arguments: PictureDisplayPageArguments(
        displayType: PictureDisplayType.network,
        urls: details.imgUrls,
        initIndex: index,
        useHero: true,
      ),
    );
  }
}

class _PageIndicator extends StatefulWidget {
  _PageIndicator(this.pageController, this.listLength);

  final PageController pageController;
  final listLength;
  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  PageController _controller;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.pageController;
    _controller.addListener(_pageListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = _controller.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(widget.listLength, (index) {
        final double pageDif = (_currentPage - index).abs();

        return Container(
          width: _indicatorSizeOf(index,pageDif),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(_indicatorOpacityOf(index,pageDif)),
          ),
        );
      }),
    );
  }

  double _indicatorSizeOf(int index,double pageDif){
    final double minSize = 6.0;
    if (pageDif > 1.0) {
      return minSize;
    } else {
      return 10.0 - 4.0 * pageDif;
    }
  }
  double _indicatorOpacityOf(int index,double pageDif) {
    final double minOpacity = 0.4;
    if (pageDif > 1.0) {
      return minOpacity;
    } else {
      return 1.0 - 0.6 * pageDif;
    }
  }
}
