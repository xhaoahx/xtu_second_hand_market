import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../common/json_serializable.dart';

class Storage {
  static const Storage instance = Storage._();

  const Storage._();

  /// ## Save
  Future<bool> saveStringWithKey(String key,String value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    return await sp.setString(key,value).catchError(_handleError);
  }

  Future<bool> saveIntWithKey(String key,int value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    return await sp.setInt(key,value).catchError(_handleError);
  }

  Future<bool> saveDoubleWithKey(String key,double value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    return await sp.setDouble(key,value).catchError(_handleError);
  }

  Future<bool> saveJsonSerializableWithKey(String key,JsonSerializable value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    try{
      final Map<String,dynamic> json = value.toJson();
      final String result = jsonEncode(json);
      return await sp.setString(key, result).catchError(_handleError);
    }catch(error,stackTrace){
      _handleError(error,stackTrace);
      return false;
    }
  }

  Future<bool> saveBoolWithKey(String key,bool value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    return await sp.setBool(key,value).catchError(_handleError);
  }

  Future<bool> saveStringListWithKey(String key,List<String> value) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return false;
    }
    return await sp.setStringList(key,value).catchError(_handleError);
  }

  /// ## Load
  Future<String> loadStringWithKey(String key) async {
    final SharedPreferences sp =
    await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    return sp.getString(key);
  }

  Future<int> loadIntWithKey(String key) async {
    final SharedPreferences sp =
        await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    return sp.getInt(key);
  }

  Future<double> loadDoubleWithKey(String key) async {
    final SharedPreferences sp =
        await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    return sp.getDouble(key);
  }

  Future<Map<String, dynamic>> loadJsonSerializableWithKey(String key) async {
    final SharedPreferences sp =
        await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    try {
      final String result = sp.getString(key);
      if(result == null){
        return null;
      }
      final Map<String, dynamic> json = jsonDecode(result);
      return json;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
      return null;
    }
  }

  Future<bool> loadBoolWithKey<T>(String key) async {
    final SharedPreferences sp =
        await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    return sp.getBool(key);
  }

  Future<List<String>> loadStringListWithKey<T>(String key) async {
    final SharedPreferences sp =
        await SharedPreferences.getInstance().catchError(_handleError);
    if (sp == null) {
      return null;
    }
    return sp.getStringList(key);
  }

  void _handleError(Error error, StackTrace stackTrace) {
    print('error: $error, stack: $stackTrace');
  }
}
