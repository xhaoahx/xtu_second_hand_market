import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum PictureDisplayType{
  memory,
  network,
}

class PictureDisplayPageArguments {
  const PictureDisplayPageArguments({
    this.displayType,
    this.useHero = true,
    this.initIndex,
    this.images,
    this.urls,
  }): assert(displayType != null),
  assert(useHero != null),
    assert(initIndex != null && initIndex > -1),
  assert(urls == null || images == null),
  assert(displayType == PictureDisplayType.network || urls == null),
  assert(displayType == PictureDisplayType.memory || images == null);

  final PictureDisplayType displayType;
  final List<Uint8List> images;
  final List<String> urls;
  final int initIndex;
  final bool useHero;

  int get childLength{
    switch(displayType){
      case PictureDisplayType.memory:
        return images.length;
      case PictureDisplayType.network:
      default:
        return urls.length;
    }
  }
}

class PictureDisplayPage extends StatelessWidget {
  const PictureDisplayPage();

  static const String routeName = '/picture_display_page';
  static PictureDisplayPage builder(BuildContext context) =>
      PictureDisplayPage();

  @override
  Widget build(BuildContext context) {
    final PictureDisplayPageArguments arguments =
        ModalRoute.of(context).settings.arguments;

    final PictureDisplayType displayType = arguments.displayType;
    final List<Uint8List> imageBytes = arguments.images;
    final List<String> urls = arguments.urls;
    final bool useHero = arguments.useHero;

    final Widget backButton = SafeArea(
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    final Widget pageView = PageView.builder(
      itemBuilder: (context, index) {
        Widget result;

        switch(displayType){
          case PictureDisplayType.memory:
            result = _buildImageByByte(imageBytes[index]);
            break;
          case PictureDisplayType.network:
          default:
            result = _buildImageByUrl(urls[index]);
            break;
        }

        if (useHero) {
        result = Hero(
          tag: 'image$index',
          child: result,
        );
      }
        return result;
      },
      itemCount: arguments.childLength,
      controller: PageController(initialPage: arguments.initIndex),
    );

    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: pageView,
            ),
          ),
          Positioned(
            left: 5.0,
            top: 5.0,
            child: backButton,
          ),
        ],
      ),
    );
  }

  Widget _buildImageByByte(Uint8List imageByte){
    return Image.memory(
      imageByte,
      fit: BoxFit.contain,
    );
  }

  Widget _buildImageByUrl(String url){
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      placeholder: (BuildContext context,String url){
        return const CircularProgressIndicator();
      },
    );
  }
}
