import 'package:flutter/foundation.dart';

mixin DisposeAware on ChangeNotifier{

  bool get disposed => _disposed;

  @override
  void notifyListeners() {
    if(!_disposed){
      super.notifyListeners();
    }else{
      assert(_debugAlertThisHasDisposed());
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    if(_disposed){
      return;
    }
    _disposed = true;
    super.dispose();
  }

  bool _disposed = false;

  bool _debugAlertThisHasDisposed(){
    print('[NotifyListener] is called after $this disposed');
    return true;
  }
}