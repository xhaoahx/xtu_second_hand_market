import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'xtu_second_market_app.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),
    );
  }
  runApp(XtuSecondHandMarketApp());
}
