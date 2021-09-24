import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/search_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/page/search_page/history_overlay.dart';
import 'package:xtusecondhandmarket/ui/page/search_page/search_result_widget.dart';

import 'search_bar.dart';



class SearchPage extends StatelessWidget {

  static const String routeName = '/search_page';
  static SearchPage builder(BuildContext context) => SearchPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageModel>(
      create: (BuildContext context) => SearchPageModel(),
      child: _SearchPage(),
    );
  }
}

class _SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final FontData fontData = ThemeModel.of(context).fontData;

    final Widget appBar = Container(
      color: themeData.primaryColor,
      height: 86.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Center(
                child: Text(
                  '搜索宝贝',
                  style: fontData.h3_2,
                ),
              )
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              width: 36.0,
              bottom: 0.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: Navigator.of(context).pop,
              ),
            )
          ],
        )
      ),
    );

    final Widget body = Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 10.0,
          right: 10.0,
          height: 36.0,
          child: ResultTitle(),
        ),
        Positioned(
          top: 36.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child:  const SearchResultWidget()
        ),
        Positioned(
          top: -4.0,
          left: 0.0,
          right: 0.0,
          height: 250.0,
          child: HistoryOverlay(),
        )
      ],
    );

    return Material(
      child: Column(
        children: <Widget>[
          appBar,
          SearchBar(),
          Expanded(
            child: body,
          )
        ],
      ),
    );
  }
}


