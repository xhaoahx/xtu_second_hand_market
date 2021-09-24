import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/ui/page/classification_page/classification_page.dart';

import '../../../logic/model/theme_model.dart';
import '../../../logic/model/global_goods_model.dart';

const double _iconSize = 50.0;
const double _childAspectRatio = 1.4;

const List<String> _iconPaths = [
  'assets/img/market_page/教材书籍@hdpi.png',
  'assets/img/market_page/家用电器@hdpi.png',
  'assets/img/market_page/数码产品@hdpi.png',
  'assets/img/market_page/美妆日化@hdpi.png',
  'assets/img/market_page/衣物鞋帽@hdpi.png',
  'assets/img/market_page/生活用品@hdpi.png',
];

class Classification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      childAspectRatio: _childAspectRatio,
      mainAxisSpacing: 3.0,
      children: List.generate(classificationCount, (index) {
        return _ClassificationWidget(
          classification: index,
          iconPath: _iconPaths[index],
          onTap: () {
            _onTap(context, index);
          },
        );
      }),
    );
  }

  void _onTap(BuildContext context, int classification) {
    Navigator.of(context).pushNamed(
      ClassificationPage.routeName,
      arguments: classification,
    );
  }
}

class _ClassificationWidget extends StatelessWidget {
  const _ClassificationWidget({
    this.classification,
    this.iconPath,
    this.onTap,
  });

  final int classification;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: _iconSize,
              width: _iconSize,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            classificationToString(classification),
            style: ThemeModel.of(context).fontData.h5_1.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }
}
