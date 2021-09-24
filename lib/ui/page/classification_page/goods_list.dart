import 'package:flutter/material.dart';

import '../../widget/special/basic_goods_list.dart';
import '../../../logic/model/global_goods_model.dart';

class GoodsList extends StatelessWidget {
  const GoodsList(this.classification,this.type,);
  final int type;
  final int classification;

  @override
  Widget build(BuildContext context) {
    return BasicGoodsList<int,GlobalGoodsModel>(
      keyValue: type,
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
    /// all goods
    if (type == 0) {
      return Tuple2<List<ShortGoodsDetails>, Object>(
        model.typed,
        model.isTypedChanged,
      );
    } else {
      return Tuple2<List<ShortGoodsDetails>, Object>(
        model.typed.where((details) => details.type == type).toList(),
        model.isTypedChanged,
      );
    }
  }

  bool _indicatorSelector(BuildContext context, GlobalGoodsModel model) {
    return model.isTypedLoading;
  }

  void _handleOverScroll(BuildContext context) {
    final GlobalGoodsModel goodsModel = GlobalGoodsModel.of(context);
    goodsModel.loadTypedGoods(classification);
  }
}
