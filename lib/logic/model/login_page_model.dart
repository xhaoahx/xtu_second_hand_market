import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';
import 'package:xtusecondhandmarket/logic/dao/user.dart';
import 'package:xtusecondhandmarket/test/user_model_test.dart';
import '../common/login.dart';

export '../common/login.dart';

class LoginPageModel with ChangeNotifier, DisposeAware {

  LoginPageModel(){
    _passwordFocusNode = FocusNode(debugLabel: 'passwordFocusNode');
    _sidFocusNode = FocusNode(debugLabel: 'sidFocusNode');
  }

  static LoginPageModel of(BuildContext context, {bool listen = false}) =>
      Provider.of(context, listen: listen);

  /// ## Getter
  String get sid => _sid;
  String get password => _password;
  bool get hasReadAgreement => _hasReadAgreement;
  FocusNode get sidFocusNode => _sidFocusNode;
  FocusNode get passwordFocus => _passwordFocusNode;

  bool get isLoading => _isLoading;
  bool get enableButton {
    return sid != null &&
        sid.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        _hasReadAgreement;
  }

  void handleAgreement(bool newValue){
    assert(newValue != null);
    if(_hasReadAgreement != newValue){
      _hasReadAgreement = newValue;
      notifyListeners();
    }
  }

  void handleSidChange(String newValue){
    _sid = newValue;
    notifyListeners();
  }

  void handlePasswordChange(String newValue){
    _password = newValue;
    notifyListeners();
  }

  Future<LoginResult> handleLogin() async {
    if(!_isLoading){
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 1500));
      _storageUser = yieldLocalUser();

      _isLoading = false;
      notifyListeners();

      return LoginResult.succeed;
    }
    return null;
  }

  void unFocusAll(){
    _passwordFocusNode.unfocus();
    _sidFocusNode.unfocus();
  }

  LocalUser asStorageUser(){
    return _storageUser;
  }

  @override
  dispose(){
    _sidFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// ## Internal
  String _sid;
  String _password;
  bool _hasReadAgreement = false;
  bool _isLoading = false;

  FocusNode _sidFocusNode;
  FocusNode _passwordFocusNode;

  LocalUser _storageUser;
}
