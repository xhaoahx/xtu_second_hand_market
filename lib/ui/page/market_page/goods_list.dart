import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/special/basic_goods_list.dart';
import '../../../logic/model/global_goods_model.dart';

class GoodsList extends StatelessWidget {
  const GoodsList(this.listType);
  final int listType;

  @override
  Widget build(BuildContext context) {
    return BasicGoodsList<int,GlobalGoodsModel>(
      keyValue: listType,
      selector: _listSelector,
      indicator: LoadingIndicator<GlobalGoodsModel>(
        selector: _indicatorSelector,
      ),
      onOverScroll: _handleOverScroll,
    );
  }

  Tuple2<List<ShortGoodsDetails>, Object> _listSelector(
    BuildContext context,
    GlobalGoodsModel model,
  ) {
    switch (listType) {
      case 0:
        return Tuple2<List<ShortGoodsDetails>, Object>(
          model.latest,
          model.isLatestChanged,
        );
      case 1:
        return Tuple2<List<ShortGoodsDetails>, Object>(
          model.recommend,
          model.isRecommendChanged,
        );
      default:
        throw Exception('Unknow type of list');
    }
  }

  bool _indicatorSelector(BuildContext context, GlobalGoodsModel model) {
    switch (listType) {
      case 0:
        return model.isLatestLoading;
      case 1:
        return model.isRecommendLoading;
      default:
        throw Exception('Unknow type of list');
    }
  }

  void _handleOverScroll(BuildContext context) {
    final GlobalGoodsModel goodsModel = GlobalGoodsModel.of(context);
    goodsModel.loadMoreGoodsOf(listType);
  }
}
