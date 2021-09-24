import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/publish_page_model.dart';
import 'package:xtusecondhandmarket/ui/page/picture_display_page/picture_display_page.dart';

import '../../../logic/common/tuple.dart';
import '../../../logic/manager/publish_page_manager.dart';

const Duration _kAnimateDuration = Duration(milliseconds: 300);
const int _kMaxPick = 5;
const double _kIconSize = 20.0;
const double _kClipRadius = 8.0;
const double _kInitSizeFactor = 0.93;

class Picture extends PublishPageRegisterWidget {
  const Picture();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<PublishPageModel, Tuple2<List<Uint8List>, Object>>(
      builder: (
        BuildContext context,
        Tuple2<List<Uint8List>, Object> tuple,
        Widget child,
      ) {
        final List<Uint8List> pictureData = tuple.valueA;

        return GridView(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 5.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          children: <Widget>[
            for (int i = 0; i < pictureData.length; i += 1)
              _buildPictureItem(context, pictureData[i], i),
            if (pictureData.length < _kMaxPick) _buildSelectItem(context),
          ],
        );
      },
      selector: (BuildContext context, PublishPageModel model) {
        return Tuple2<List<Uint8List>, Object>(
          model.pictureManager.pictureDataList,
          model.pictureManager.isPictureChanged,
        );
      },
      shouldRebuild: (
        Tuple2<List<Uint8List>, Object> previous,
        Tuple2<List<Uint8List>, Object> next,
      ) {
        return previous.valueB != next.valueB;
      },
    );
  }

  @override
  PublishPageSection get section => PublishPageSection.picture;

  Widget _buildPictureItem(
    BuildContext context,
    Uint8List image,
    int index,
  ) {
    return _PictureItem(
      index: index,
      isMainPic: index == 0,
      image: image,
    );
  }

  Widget _buildSelectItem(BuildContext context) {
    return _SelectItem(() async {
      PublishPageModel.of(context).selectLocalPicture();
    });
  }
}

class _PictureItem extends StatefulWidget {
  const _PictureItem({
    this.image,
    this.index,
    this.isMainPic,
  });

  final Uint8List image;
  final int index;
  final bool isMainPic;

  @override
  _PictureItemState createState() => _PictureItemState();
}

class _PictureItemState extends State<_PictureItem>
    with SingleTickerProviderStateMixin<_PictureItem> {
  bool _isOperating = false;
  set isOperating(bool newValue) {
    if (_isOperating == newValue) {
      return;
    }
    if (_isOperating) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isOperating = newValue;
  }

  AnimationController _controller;
  final Tween<double> _scaleTween = Tween(
    begin: _kInitSizeFactor,
    end: 1.0,
  );

  @override
  void didChangeDependencies() {
    isOperating = (PublishPageModel.of(context,listen: true).operatingIndex == widget.index);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kAnimateDuration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOperating = PublishPageModel.of(context).isOperating;

    final Widget picture = AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return Transform.scale(
          scale: _scaleTween.evaluate(_controller),
          child: child,
        );
      },
      animation: _controller,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(_kClipRadius),
          child: Hero(
            tag: 'image${widget.index}',
            child: Image.memory(
              widget.image,
              fit: BoxFit.cover,
            ),
          )),
    );

    final Widget setMainPicture = FadeTransition(
      child: GestureDetector(
        onTap: _handleSetMainPicture,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          alignment: Alignment.center,
          child: Text(
            '主',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      opacity: _controller,
    );

    final Widget removePicture = FadeTransition(
      child: GestureDetector(
        onTap: _handleRemovePicture,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(
            Icons.close,
            size: _kIconSize,
            color: Colors.white,
          ),
        ),
      ),
      opacity: _controller,
    );

    return GestureDetector(
      onLongPress: _handleLongPress,
      onTap: _handleTap,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned.fill(
            child: picture,
          ),
          Positioned(
            top: -3.0,
            left: -3.0,
            width: _kIconSize,
            height: _kIconSize,
            child: setMainPicture,
          ),
          Positioned(
            top: -3.0,
            right: -3.0,
            width: _kIconSize,
            height: _kIconSize,
            child: removePicture,
          ),
          if (widget.isMainPic && !isOperating) _mainPicTag
        ],
      ),
    );
  }

  void _handleSetMainPicture() {
    if (_isOperating) {
      final PublishPageModel model = PublishPageModel.of(context);
      model.handleSetMainPicture(widget.index);
      model.changeOperatingIndex(0);
    }
  }

  void _handleRemovePicture() {
    if (_isOperating) {
      final PublishPageModel model = PublishPageModel.of(context);
      model.cancelOperating();
      model.handleRemovePictureAt(widget.index);
    }
  }

  void _handleLongPress() {
    print('longpress');
    if (_isOperating) {
      PublishPageModel.of(context).cancelOperating();
    } else {
      PublishPageModel.of(context).changeOperatingIndex(widget.index);
    }
  }

  void _handleTap() {
    final PublishPageModel model = PublishPageModel.of(context);
    if (!_isOperating) {
      model.focusNodeManager.unFocusAll();

      Navigator.of(context).pushNamed(
        PictureDisplayPage.routeName,
        arguments: PictureDisplayPageArguments(
          displayType: PictureDisplayType.memory,
          images: model.pictureManager.pictureDataList,
          initIndex: widget.index,
          useHero: true,
        ),
      );
    } else {
      model.cancelOperating();
    }
  }

  final Widget _mainPicTag = Positioned(
    left: 10.0,
    top: 10.0,
    child: Builder(
      builder: (context) {
        return Container(
          width: 40.0,
          height: 20.0,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0)),
          child: const Text(
            '主图',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        );
      },
    ),
  );
}

class _SelectItem extends StatelessWidget {
  const _SelectItem(this.onTap);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FractionallySizedBox(
        heightFactor: _kInitSizeFactor,
        widthFactor: _kInitSizeFactor,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(_kClipRadius),
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/img/publish_page/相机@hdpi.png',
            scale: 1.3,
          ),
          alignment: Alignment.center,
        ),
      ),
      onTap: onTap,
    );
  }
}
