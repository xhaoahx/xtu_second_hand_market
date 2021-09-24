import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/search_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import 'package:xtusecondhandmarket/ui/widget/common/decorated_text.dart';

import '../../widget/special/basic_goods_list.dart';
import '../../../logic/model/global_goods_model.dart';

class ResultTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SearchPageModel, bool>(
      builder: (
        BuildContext context,
        bool isEmpty,
        Widget child,
      ) {
        return AnimatedOpacity(
          opacity: isEmpty ? 0.0 : 1.0,
          child: child,
          duration: const Duration(milliseconds: 400),
        );
      },
      selector: (BuildContext context, SearchPageModel model) {
        return model.isResultChanged == null;
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedText(
          TextSpan(
            text: '搜索结果',
            style: ThemeModel.of(context)
                .fontData
                .h4_4
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget();

  @override
  Widget build(BuildContext context) {
    return Selector<SearchPageModel, bool>(
      builder: (
        BuildContext context,
        bool isEmpty,
        Widget child,
      ) {
        return isEmpty ? NoResultWidget() : GoodsList();
      },
      selector: (BuildContext context, SearchPageModel model) {
        return model.isResultChanged != null &&
            !model.isSearchLoading &&
            model.searchResult.isEmpty;
      },
    );
  }
}

class GoodsList extends StatelessWidget {
  const GoodsList();

  @override
  Widget build(BuildContext context) {
    return BasicGoodsList<Null, SearchPageModel>(
      keyValue: null,
      selector: _listSelector,
      indicator: LoadingIndicator<SearchPageModel>(
        selector: _indicatorSelector,
      ),
      useAbsorber: false,
      scrollController: SearchPageModel.of(context).scrollController,
      onOverScroll: _handleOverScroll,
    );
  }

  Tuple2<List<ShortGoodsDetails>, Object> _listSelector(
    BuildContext context,
    SearchPageModel model,
  ) {
    return Tuple2<List<ShortGoodsDetails>, Object>(
      model.searchResult,
      model.isResultChanged,
    );
  }

  bool _indicatorSelector(BuildContext context, SearchPageModel model) {
    return model.isSearchLoading;
  }

  void _handleOverScroll(BuildContext context) {
    final SearchPageModel model = SearchPageModel.of(context);
    model.searchGoods();
  }
}

class NoResultWidget extends StatelessWidget {
  const NoResultWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/img/search_page/空搜索@hdpi.png',
          fit: BoxFit.cover,
          scale: 1.2,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          '没有找到相关宝贝，去首页翻翻看吧',
          style: ThemeModel.of(context).fontData.h5_2,
        )
      ],
    );
  }
}
