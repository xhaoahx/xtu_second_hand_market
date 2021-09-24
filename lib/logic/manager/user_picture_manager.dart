import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtusecondhandmarket/logic/common/storage.dart';
import 'package:xtusecondhandmarket/logic/config/storage_key.dart';
import '../model/publish_page_model.dart';

const _kMaxPicture = 5;

const String _statusBarColor = '#ffe896';

typedef PictureCompressor = Stream<Uint8List> Function(List<Asset> assets);

enum SelectPictureResult {
  exceedMaxQuantity,
  permissionDenied,
  permissionPermanentlyDenied,
  succeed,
  none,
  unKnowError
}

class UserPictureManager {
  UserPictureManager({
    this.compressor = _defaultPictureCompressor,
  });

  final PictureCompressor compressor;

  Object get isPictureChanged => _isPictureChanged;

  int get pictureCount {
    return _pictureDataList.length;
  }

  List<Uint8List> get pictureDataList => _pictureDataList;

  Future<SelectPictureResult> selectLocalPicture(
      [bool compress = false]) async {
    assert(compress != null);

    if (_pictureDataList.length >= _kMaxPicture) {
      return SelectPictureResult.exceedMaxQuantity;
    }

    List<Asset> newAssets;
    try {
      newAssets = await MultiImagePicker.pickImages(
        maxImages: _kMaxPicture - _pictureDataList.length,
        materialOptions: const MaterialOptions(
            actionBarColor: _statusBarColor,
            statusBarColor: _statusBarColor,
            actionBarTitle: '选择图片',
            allViewTitle: '选择图片',
            selectionLimitReachedText: '最多选择五张图片上传！',
            textOnNothingSelected: '还没有选中图片'),
        cupertinoOptions: const CupertinoOptions(
          backgroundColor: _statusBarColor,
        ),
      );
    } on NoImagesSelectedException {
      print('No image selected');
      return Future<SelectPictureResult>.value(SelectPictureResult.none);
    } on PermissionDeniedException {
      return Future<SelectPictureResult>.value(
          SelectPictureResult.permissionDenied);
    } on PermissionPermanentlyDeniedExeption {
      return Future<SelectPictureResult>.value(
          SelectPictureResult.permissionPermanentlyDenied);
    } catch (e, stackTrace) {
      print('Exception: $e');
      print(stackTrace);
      return Future<SelectPictureResult>.value(SelectPictureResult.unKnowError);
    }

    if (newAssets == null || newAssets.isEmpty) {
      return SelectPictureResult.none;
    }

    List<Uint8List> newPictureData;

    if (compress) {
      newPictureData = await compressor(newAssets)
          .toList()
          .catchError((error, stackTrace) async {
        print('$error,$stackTrace');
        newPictureData = await _defaultPictureCompressor(newAssets).toList();
      });
    } else {
      newPictureData = await _defaultPictureCompressor(newAssets).toList();
    }

    _pictureDataList.addAll(newPictureData);

    _isPictureChanged = new Object();

    return SelectPictureResult.succeed;
  }

  void removePictureAt(int index) {
    assert(index < _pictureDataList.length);
    _pictureDataList.removeAt(index);
    _isPictureChanged = new Object();
  }

  void setMainPicture(int index) {
    assert(index < _pictureDataList.length);
    _pictureDataList.insert(0, _pictureDataList.removeAt(index));
    _isPictureChanged = new Object();
  }

  void dispose() {}

  Future<bool> localSavePictureData() async {
    if (_pictureDataList == null || _pictureDataList.isEmpty) {
      return true;
    }

    try {
      final List<String> pictureDataStringList =
          _pictureDataList.map<String>((Uint8List pictureData) {
        return String.fromCharCodes(pictureData);
      }).toList(growable: false);

      return await Storage.instance.saveStringListWithKey(
        StorageKey.localPublishPicture,
        pictureDataStringList,
      );
    } catch (e, stack) {
      print(e);
      print(stack);

      return false;
    }
  }

  Future<void> localLoadPictureData() async {
    try {
      final List<String> pictureDataStringList = await Storage.instance
          .loadStringListWithKey(StorageKey.localPublishPicture);

      if(pictureDataStringList == null){
        return;
      }
      _pictureDataList = pictureDataStringList.map<Uint8List>((String data) {
        return Uint8List.fromList(data.codeUnits);
      }).toList();
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    _isPictureChanged = new Object();
  }

  /// ## Internal
  List<Uint8List> _pictureDataList = [];
  Object _isPictureChanged;

  // do nothing but return the raw UInt8List
  static Stream<Uint8List> _defaultPictureCompressor(
      List<Asset> assets) async* {
    for (Asset asset in assets) {
      yield await asset.getByteData().then(
            (ByteData byteData) => byteData.buffer.asUint8List(),
          );
    }
  }
}
