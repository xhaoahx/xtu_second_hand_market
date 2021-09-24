import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../logic/model/theme_model.dart';

class ClassificationPageAppBar extends StatelessWidget {

  const ClassificationPageAppBar({this.title,this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86.0,
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: onTap,
            ),
            Text(
              title,
              style: ThemeModel.of(context).fontData.h3_1,
            )
          ],
        ),
      ),
    );
  }
}
