import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';
import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/test/details_model_test.dart';

import '../../test/goods_model_test.dart';

class CollectionPageModel with ChangeNotifier, DisposeAware {
  static CollectionPageModel of(BuildContext context, {bool listen = false}) =>
      Provider.of(
        context,
        listen: listen,
      );


  List<FullGoodsDetails> get collection => _collections;
  Object get isCollectionChanged => _isCollectionChanged;
  bool get isLoading => _isLoading;
  bool get isCollectionEmpty => _collections.isEmpty;

  @override
  void dispose(){
    super.dispose();
    print('collection_model disepose');
  }


  Future<void> loadCollection(int userId) async {
    if(_isLoading){
      return;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1400));

    _collections.addAll(List<FullGoodsDetails>.generate(10, (index){
      return yieldFullGoodsDetails();
    }));

    _isCollectionChanged = new Object();

    _isLoading = false;
    notifyListeners();
  }


  void handleCancelLike(FullGoodsDetails details){
    final result = _collections.remove(details);
    if(result){
      _isCollectionChanged = new Object();
      notifyListeners();
    }
  }

  List<FullGoodsDetails> _collections = [];
  Object _isCollectionChanged;
  bool _isLoading = false;
}
