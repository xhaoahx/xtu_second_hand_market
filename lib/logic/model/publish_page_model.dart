import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';

import 'package:xtusecondhandmarket/logic/common/publish.dart';
import 'package:xtusecondhandmarket/logic/common/storage.dart';
import 'package:xtusecondhandmarket/logic/config/storage_key.dart';
import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';

import '../manager/user_picture_manager.dart';
import '../manager/publish_page_manager.dart';
import '../manager/focus_node_manager.dart';

export '../manager/user_picture_manager.dart';
export '../manager/publish_page_manager.dart';
export '../manager/focus_node_manager.dart';
export '../common/publish.dart';

const int _defaultNullIndex = -1;

class PublishPageModel
    with ChangeNotifier, DisposeAware, WidgetsBindingObserver {
  PublishPageModel() {
    _initManagers();
    WidgetsBinding.instance.addObserver(this);
  }

  /// ## Getter
  PublishPageManager get pageManager => _pageManager;
  UserPictureManager get pictureManager => _pictureManager;
  FocusNodeManager get focusNodeManager => _focusNodeManager;

  String get phoneNum => _phoneNum;
  String get oldPrice => _oldPrice;
  String get newPrice => _newPrice;
  String get qqNum => _qqNum;
  String get wxNum => _wxNum;
  String get title => _title;
  String get description => _description;

  bool get isNew => _isNew;

  int get operatingIndex => _operatingIndex;
  int get gradeIndex => _gradeIndex;
  int get dormitoryIndex => _dormitoryIndex;
  int get onlineWayIndex => _onlineWayIndex;
  int get classificationIndex => _classificationIndex;
  int get typeIndex => _typeIndex;
  int get purchaseWayIndex => _purChaseWayIndex;

  bool get isOperating => _operatingIndex != _defaultNullIndex;

  /// ## Setter
  set title(String newValue) {
    _title = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.title)..text = _title;
  }

  set oldPrice(String newValue) {
    _oldPrice = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.oldPrice)
      ..text = _oldPrice;
  }

  set newPrice(String newValue) {
    _newPrice = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.newPrice)
      ..text = _newPrice;
  }

  set qqNum(String newValue) {
    _qqNum = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.qqNum)..text = _qqNum;
  }

  set wxNum(String newValue) {
    _wxNum = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.wxNum)..text = _wxNum;
  }

  set description(String newValue) {
    _description = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.description)
      ..text = _description;
  }

  set phoneNum(String newValue) {
    _phoneNum = newValue;
    _focusNodeManager.controllerOf(PublishPageSection.phoneNum)
      ..text = _phoneNum;
  }

  /// ## Method
  static PublishPageModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<PublishPageModel>(context, listen: listen);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      localSaveEditing();
    }
    super.didChangeAppLifecycleState(state);
  }

  /// #### String change handler
  void handleTitleChange(String newValue) {
    title = newValue;
  }

  void handleDescriptionChange(String newValue) {
    description = newValue;
  }

  void handlePhoneNumChange(String newValue) {
    phoneNum = newValue;
  }

  void handleNewPriceChange(String newValue) {
    newPrice = newValue;
  }

  void handleOldPriceChange(String newValue) {
    oldPrice = newValue;
  }

  void handleQQNumChange(String newValue) {
    qqNum = newValue;
  }

  void handleWXNumChange(String newValue) {
    wxNum = newValue;
  }

  /// #### Normal fields change handler
  void handleIsNewChange(bool newValue) {
    assert(newValue != null);
    _isNew = newValue;
    notifyListeners();
  }

  Future<void> selectLocalPicture() async {
    await _pictureManager.selectLocalPicture();
    notifyListeners();
  }

  void handleRemovePictureAt(int index) {
    _pictureManager.removePictureAt(index);
    notifyListeners();
  }

  void handleSetMainPicture(int index) {
    _pictureManager.setMainPicture(index);
    notifyListeners();
  }

  void changeOperatingIndex(int index) {
    _operatingIndex = index;
    notifyListeners();
  }

  void cancelOperating() {
    _operatingIndex = _defaultNullIndex;
    notifyListeners();
  }

  void handleGradeChange(int index) {
    if (index != _gradeIndex) {
      _gradeIndex = index;
      notifyListeners();
    }
  }

  void handleDormitoryChange(int index) {
    if (index != _dormitoryIndex) {
      _dormitoryIndex = index;
      notifyListeners();
    }
  }

  void handleClassificationChange(int index) {
    if (index != _classificationIndex) {
      _classificationIndex = index;
      // set typeIndex to _defaultNullIndex to reset type buttons
      _typeIndex = _defaultNullIndex;
      notifyListeners();
    }
  }

  void handleTypeChange(int index) {
    if (index != _typeIndex) {
      _typeIndex = index;
      notifyListeners();
    }
  }

  void handlePurchaseWayChange(int index) {
    if (index != _purChaseWayIndex) {
      _purChaseWayIndex = index;
      notifyListeners();
    }
  }

  void handleOnlineWayChange(int index) {
    if (index != _onlineWayIndex) {
      _onlineWayIndex = index;
      notifyListeners();
    }
  }

  Future<PublishResult> handlePublish() async {
    PublishResult result;
    result = _checkInfoIsValid();
    if (result == null) {
      result = await _handlePublish();
    }
    return result;
  }

  /// ## Local storage
  Future<bool> localSaveEditing() async {
    bool result = await pictureManager.localSavePictureData();
    if(result){
      Storage.instance.saveJsonSerializableWithKey(
        StorageKey.localPublishEdit,
        _asFullGoodsDetails(),
      );
    }
    return result;
  }

  Future<bool> localKeyInfo() async {
    final result = await Storage.instance.saveJsonSerializableWithKey(
      StorageKey.localPublishKeyInfo,
      _asKeyInfoDetails(),
    );

    return result;
  }

  Future<void> localLoadEditing() async {
    await pictureManager.localLoadPictureData();
    final Map<String, dynamic> json = await Storage.instance
        .loadJsonSerializableWithKey(StorageKey.localPublishEdit);
    _fromFullGoodsDetails(FullGoodsDetails.fromJson(json));
  }

  Future<void> localLoadKeyInfo() async {
    final Map<String, dynamic> json = await Storage.instance
        .loadJsonSerializableWithKey(StorageKey.localPublishKeyInfo);
    _fromFullGoodsDetails(FullGoodsDetails.fromJson(json));
  }

  @override
  void dispose() {
    _pageManager.pageController.removeListener(_pageScrollListener);
    _pageManager.dispose();
    _pictureManager.dispose();
    _focusNodeManager.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// ## Internal
  PublishPageManager _pageManager;
  UserPictureManager _pictureManager;
  FocusNodeManager _focusNodeManager;

  bool _isNew;

  String _title;
  String _description;
  String _qqNum;
  String _wxNum;
  String _phoneNum;
  String _oldPrice;
  String _newPrice;

  int _operatingIndex = _defaultNullIndex;
  int _gradeIndex = 0;
  int _dormitoryIndex = 0;
  int _onlineWayIndex = _defaultNullIndex;
  int _classificationIndex = 0;
  int _typeIndex = _defaultNullIndex;
  int _purChaseWayIndex = 0;

  void _pageScrollListener() {
    if (!focusNodeManager.isInternalScroll) {
      focusNodeManager.unFocusAll();
    }
  }

  FullGoodsDetails _asFullGoodsDetails() {
    return FullGoodsDetails(
      title: _title,
      description: _description,
      dormitory: _dormitoryIndex,
      isNew: _isNew,
      type: _typeIndex,
      classification: _classificationIndex,
      oldPrice: _oldPrice,
      newPrice: _newPrice,
      grade: _gradeIndex,
      onlineWay: _onlineWayIndex,
      onlineNum: _onlineWayIndex == 0 ? _qqNum : _wxNum,
      phoneNum: _phoneNum,
      purchaseWay: _purChaseWayIndex,
    );
  }

  FullGoodsDetails _asKeyInfoDetails() {
    return FullGoodsDetails(
      dormitory: _dormitoryIndex,
      grade: _gradeIndex,
      onlineWay: _onlineWayIndex,
      onlineNum: _onlineWayIndex == 0 ? _qqNum : _wxNum,
      phoneNum: _phoneNum,
      purchaseWay: _purChaseWayIndex,
    );
  }

  void _fromFullGoodsDetails(FullGoodsDetails details) {
    // String field use setter to notify
    title = details.title;
    description = details.description;
    qqNum = details.onlineNum;
    wxNum = details.onlineNum;
    oldPrice = details.oldPrice?.toString();
    newPrice = details.newPrice?.toString();

    _isNew = details.isNew;

    // Must call notifyListener
    _dormitoryIndex = details.dormitory;
    _typeIndex = details.type;
    _classificationIndex = details.classification;
    _gradeIndex = details.grade;
    _onlineWayIndex = details.onlineWay;
    _purChaseWayIndex = details.purchaseWay;
  }

  Future<PublishResult> _handlePublish() async {
    /// todo: implements publish
    await Future.delayed(const Duration(milliseconds: 2000));
    return PublishResult.succeed;
  }

  PublishResult _checkInfoIsValid() {
    if (title == null || title.isEmpty) {
      _pageManager.showSection(PublishPageSection.title);
      return PublishResult.emptyTitle;
    }
    if (description == null || description.isEmpty) {
      _pageManager.showSection(PublishPageSection.description);
      return PublishResult.emptyDescription;
    }
    if (_pictureManager.pictureDataList.length == 0) {
      _pageManager.showSection(PublishPageSection.picture);
      return PublishResult.emptyPicture;
    }
    if (_phoneNum == null || _phoneNum.isEmpty) {
      _pageManager.showSection(PublishPageSection.phoneNum);
      return PublishResult.emptyPhoneNum;
    }
    if (_onlineWayIndex == null || _onlineWayIndex == _defaultNullIndex) {
      _pageManager.showSection(PublishPageSection.onlineWay);
      return PublishResult.emptyOnlineWay;
    }
    if (_onlineWayIndex == 0 && (_qqNum == null || _qqNum.isEmpty)) {
      _pageManager.showSection(PublishPageSection.onlineNum);
      return PublishResult.emptyQQNum;
    }
    if (_onlineWayIndex == 1 && (_wxNum == null || _wxNum.isEmpty)) {
      _pageManager.showSection(PublishPageSection.onlineNum);
      return PublishResult.emptyWXNum;
    }
    if (_oldPrice == null || _oldPrice.isEmpty) {
      _pageManager.showSection(PublishPageSection.oldPrice);
      return PublishResult.emptyOldPrice;
    }
    if (_newPrice == null || _newPrice.isEmpty) {
      _pageManager.showSection(PublishPageSection.newPrice);
      return PublishResult.emptyNewPrice;
    }
    if (_typeIndex == null || _typeIndex == _defaultNullIndex) {
      _pageManager.showSection(PublishPageSection.tag);
      return PublishResult.emptyTag;
    }
    return null;
  }

  void _initManagers() {
    _pageManager = PublishPageManager();
    _pictureManager = UserPictureManager();
    _focusNodeManager = FocusNodeManager();
    _pageManager.pageController.addListener(_pageScrollListener);
  }

  /// ## Debug
}
