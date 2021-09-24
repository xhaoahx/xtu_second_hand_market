import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';

import '../../test/goods_model_test.dart';
import '../dao/goods_details.dart';

export '../dao/goods_details.dart';

class SearchPageModel with ChangeNotifier,DisposeAware{
  SearchPageModel(){
    _focusNode = FocusNode()
    ..addListener(notifyListeners);
    _editingController = TextEditingController();
    _scrollController = ScrollController()..addListener(notifyListeners);
  }

  bool get isEditing => _focusNode.hasFocus;
  bool get enableEditing{
    bool result = true;
    if(scrollController.hasClients){
      // ignore: invalid_use_of_protected_member
      result = !scrollController.position.activity.isScrolling;
    }
    return !_isSearchLoading && result;
  }

  String get searchContent => _searchContent;

  List<String> get hotSearch => _hotSearch;

  List<String> get searchHistory => _searchHistory;
  bool get isLoadingHistory => _isLoadingHistory;

  List<ShortGoodsDetails> get searchResult => _searchResult;
  bool get isSearchLoading => _isSearchLoading;
  Object get isResultChanged => _isResultChanged;

  FocusNode get focusNode => _focusNode;
  TextEditingController get editingController => _editingController;
  ScrollController get scrollController => _scrollController;


  void handleSearchContentChange(String newValue){
    _searchContent = newValue;
  }

  void handleSearchHistory(String history){
    _searchContent = history;
    _editingController.text = history;
    handleSearchGoods();
  }

  // handler for onTapSearchButton
  void handleSearchGoods(){
    _focusNode.unfocus();
    if(_previousSearchContent == _searchContent){
      return;
    }
    clearResult();
    searchGoods();
    _previousSearchContent = _searchContent;
  }

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    _searchHistory = searchHistoryTest;
    _isLoadingHistory = false;
    notifyListeners();
  }

  Future<void> searchGoods() async {
    if (_isSearchLoading) {
      return;
    }

    _isSearchLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    if(_searchContent.isNotEmpty){
      _searchResult.addAll(yieldRandomGoodsDetailsShort(10));
    }

    if (_resultNeedsClear) {
      _clearResult();
    }

    _isResultChanged = new Object();
    _isSearchLoading = false;

    notifyListeners();
  }

  void clearResult() {
    if (_isSearchLoading) {
      _resultNeedsClear = true;
    } else {
      _clearResult();
    }
  }

  @override
  void dispose() {
    print('search model dispose');
    _focusNode.dispose();
    _editingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static SearchPageModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<SearchPageModel>(context, listen: listen);

  /// ## Internal
  String _searchContent;

  String _previousSearchContent;

  List<String> _hotSearch;

  List<String> _searchHistory = searchHistoryTest;
  bool _isLoadingHistory = false;

  List<ShortGoodsDetails> _searchResult = [];
  bool _resultNeedsClear = false;
  bool _isSearchLoading = false;

  Object _isResultChanged;

  FocusNode _focusNode;
  ScrollController _scrollController;
  TextEditingController _editingController;

  void _clearResult() {
    assert(!_isSearchLoading);
    _searchResult.clear();
    _isResultChanged = new Object();
    _resultNeedsClear = false;
  }

}
