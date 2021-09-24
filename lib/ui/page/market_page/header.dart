import 'package:flutter/material.dart';

import '../../../logic/model/theme_model.dart';

import '../search_page/search_page.dart';

const double _kHeaderHeight = 200.0;
const double _kSearchBarHeight = 40.0;

const String _searchText = '请输入关键字';

class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final double paddingWidth = MediaQuery.of(context).size.width * 0.04;

    final Widget searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kSearchBarHeight * 0.5)
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search),
            Text(_searchText)
          ],
        ),
        onPressed: (){
          _onSearchBarTap(context);
        },
      ),
    );

    final Widget banner = Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
                image: AssetImage(
                  'assets/img/market_page/首页banner@hdpi.png',
                ),
                fit: BoxFit.contain
            )
        ),
      ),
    );

    final Widget result = Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          height: _kHeaderHeight * 0.6,
          left: 0.0,
          right: 0.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: ThemeConfig.primaryThemeColor,
            ),
          ),
        ),
        Positioned(
          left: paddingWidth,
          right: paddingWidth,
          top: 5.0,
          height: _kSearchBarHeight,
          child: searchBar,
        ),
        Positioned(
          top: _kSearchBarHeight + 5.0,
          left: paddingWidth,
          right: paddingWidth,
          bottom: 0.0,
          child: banner,
        ),
      ],
    );

    return SliverToBoxAdapter(
      child: SizedBox(
        height: _kHeaderHeight,
        child: result,
      ),
    );
  }

  void _onSearchBarTap(BuildContext context){
    Navigator.of(context).pushNamed(SearchPage.routeName);
  }

  void _onBannerTap(BuildContext context){

  }
}
