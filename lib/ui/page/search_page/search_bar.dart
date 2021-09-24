import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:xtusecondhandmarket/logic/model/search_page_model.dart';

const String _hintText = '请输入关键字';
const int _kMaxInputLength = 15;
const double _kSearchBarHeight = 40.0;

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchPageModel model = SearchPageModel.of(context);
    final ThemeData themeData = Theme.of(context);

    final Widget searchButton = IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        onPressed: model.handleSearchGoods);

    final Widget closeButton = IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.grey,
      ),
      onPressed: model.focusNode.unfocus,
    );

    final Widget textField = Selector<SearchPageModel, bool>(
      builder: (BuildContext context, bool enabled, Widget child) {
        return TextField(
          enabled: enabled,
          controller: model.editingController,
          focusNode: model.focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _hintText,
          ),
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(_kMaxInputLength)
          ],
          minLines: 1,
          maxLines: 1,
          cursorColor: themeData.primaryColor,
          onChanged: model.handleSearchContentChange,
          autofocus: false,
          maxLengthEnforced: true,
        );
      },
      selector: (BuildContext context, SearchPageModel model) => model.enableEditing
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      height: _kSearchBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kSearchBarHeight * 0.5),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          searchButton,
          Expanded(
            child: textField,
          ),
          closeButton,
        ],
      ),
    );
  }
}
