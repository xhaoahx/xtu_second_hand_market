import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';

import '../../test/goods_model_test.dart';

import 'global_user_model.dart';
import '../dao/goods_details.dart';

export '../common/goods.dart';
export '../dao/goods_details.dart';

class GlobalGoodsModel with ChangeNotifier,DisposeAware{

  /// ## Getter
  List<ShortGoodsDetails> get latest => _latestGoodsList;
  bool get hasLatest => _latestGoodsList.isNotEmpty;
  bool get isLatestLoading => _isLatestLoading;
  // flag for ui to control rebuild
  Object get isLatestChanged => _isLatestChanged;

  List<ShortGoodsDetails> get recommend => _recommendGoodsList;
  bool get hasRecommend => _recommendGoodsList.isNotEmpty;
  bool get isRecommendLoading => _isRecommendLoading;
  // flag for ui to control rebuild
  Object get isRecommendChanged => _isRecommendChanged;

  List<ShortGoodsDetails> get typed => _typedGoodsList;
  bool get hasTyped => _typedGoodsList.isNotEmpty;
  bool get isTypedLoading => _isTypedLoading;
  // flag for ui to control rebuild
  Object get isTypedChanged => _isTypedChanged;

  /// ## Method
  static GlobalGoodsModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<GlobalGoodsModel>(context, listen: listen);

  void loadMoreGoodsOf(int listType) {
    switch (listType) {
      case 0:
        _loadLatest();
        break;
      case 1:
        _loadRecommend();
        break;
    }
  }


  Future<void> loadTypedGoods(int classification) async {
    if (_isTypedLoading) {
      return;
    }

    _isTypedLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    _typedGoodsList.addAll(yieldRandomGoodsDetailsShort(10));

    if (_typedNeedsClear) {
      _clearTypedGoods();
    }

    _isTypedChanged = new Object();
    _isTypedLoading = false;
    notifyListeners();
  }

  void clearTypedGoods() {
    if (_isTypedLoading) {
      _typedNeedsClear = true;
    } else {
      _clearTypedGoods();
    }
  }

  @override
  void dispose() {
    _latestGoodsList = null;
    _recommendGoodsList = null;
    _typedGoodsList = null;
    super.dispose();
  }

  /// ## Internal
  ///

  List<ShortGoodsDetails> _latestGoodsList = [];
  bool _isLatestLoading = false;
  Object _isLatestChanged;

  List<ShortGoodsDetails> _recommendGoodsList = [];
  bool _isRecommendLoading = false;
  Object _isRecommendChanged;

  List<ShortGoodsDetails> _typedGoodsList = [];
  bool _isTypedLoading = false;
  bool _typedNeedsClear = false;
  Object _isTypedChanged;

  Future<void> _loadLatest() async {
    if (_isLatestLoading) {
      return;
    }

    _isLatestLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    _latestGoodsList.addAll(yieldRandomGoodsDetailsShort(10));

    _isLatestChanged = new Object();
    _isLatestLoading = false;
    notifyListeners();
  }

  Future<void> _loadRecommend() async {
    if (_isRecommendLoading) {
      return;
    }
    _isRecommendLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    _recommendGoodsList.addAll(yieldRandomGoodsDetailsShort(10));

    _isRecommendChanged = new Object();
    _isRecommendLoading = false;
    notifyListeners();
  }


  void _clearTypedGoods() {
    assert(!_isTypedLoading);
    _typedGoodsList.clear();
    _isTypedChanged = new Object();
    _typedNeedsClear = false;
  }


  /// ## Debug
}
