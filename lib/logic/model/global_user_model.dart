import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';
import 'package:xtusecondhandmarket/logic/config/storage_key.dart';
import 'dart:convert';

import '../dao/user.dart';

export '../dao/user.dart';

class GlobalUserModel with ChangeNotifier, DisposeAware {
  User get user => _user;

  bool get isUserLogin => _user != null;

  Future<void> loadUser() async {
    _user = await _localLoadUser();
    print(_user);
   // notifyListeners();
  }

  void handleLoginSucceed(LocalUser user) {
    _user = user;
    notifyListeners();
    _localSaveUser();
  }


  Future<LocalUser> _localLoadUser() async {
    try{
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final String result = sp.getString(StorageKey.localUser);
      print('localUser result: $result');
      if (result != null) {
        return LocalUser.fromJson(jsonDecode(result));
      }
    }catch(error){
      print(error);
    }
    return null;
  }

  Future<void> _localClearUser() async {
    try {
      assert(_user != null);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.remove(StorageKey.localUser);
      print('after remove: ${sp.getString(StorageKey.localUser)}');
    } catch (error) {
      print(error);
    }
  }

  Future<void> _localSaveUser() async {
    try {
      assert(_user != null);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(StorageKey.localUser, jsonEncode(_user.toJson()));

    } catch (error) {
      print(error);
    }
  }

  void handleUnLogin(){
    _localClearUser();
    _user = null;
    notifyListeners();
  }

  /// ## Method
  static GlobalUserModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<GlobalUserModel>(context, listen: listen);

  /// ## Internal
  LocalUser _user;
}
