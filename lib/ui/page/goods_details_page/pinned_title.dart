import 'package:flutter/material.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';

import '../../widget/common/decorated_text.dart';

const double _kPinnedHeaderHeight = 56.0;

class PinnedTitleDelegate extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedText(
            TextSpan(
              text: '留言' ,
              style: ThemeModel.of(context).fontData.h4_4.copyWith(
                  fontSize: 20.0,
              ),
            )
        ),
      ),
    );
  }

  @override
  double get maxExtent => _kPinnedHeaderHeight;

  @override
  double get minExtent => _kPinnedHeaderHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}