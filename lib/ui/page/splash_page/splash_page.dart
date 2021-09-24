import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../logic/model/publish_page_model.dart';
import '../../../logic/model/global_user_model.dart';
import '../router.dart';

const Duration _kWaitingDuration = Duration(milliseconds: 1500);

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initAppStatus();
    _scheduleDelayedJumpToNavigation();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Image.asset(
        'assets/img/splash_page/splash_page.jpg',
        fit: BoxFit.fitWidth,
      ),
      onWillPop: () => Future<bool>.value(false),
    );
  }

  void _initAppStatus() {
    SchedulerBinding.instance.addPostFrameCallback(_initStatusCallback);
  }

  Future<void> _initStatusCallback(Duration timestamp) async {
    final GlobalUserModel userModel = GlobalUserModel.of(context);
    final PublishPageModel publishModel = PublishPageModel.of(context);

    try {
      await Future.wait([
        userModel.loadUser(),
        publishModel.localLoadEditing(),
      ]);
      _loadingAppCompleter.complete();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future<void> _scheduleDelayedJumpToNavigation() async {
    await Future.wait([
      Future.delayed(_kWaitingDuration),
      _loadingAppCompleter.future,
    ]);
    Navigator.of(context).pushReplacementNamed(Router.navigation);
  }

  Completer<void> _loadingAppCompleter = Completer();
}


