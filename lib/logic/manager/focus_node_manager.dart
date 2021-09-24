import 'package:flutter/material.dart' show FocusNode, TextEditingController;

import '../common/publish.dart';
import '../model/publish_page_model.dart';

const List<PublishPageSection> _focusNodeOwners = [
  PublishPageSection.title,
  PublishPageSection.description,
  PublishPageSection.phoneNum,
  PublishPageSection.qqNum,
  PublishPageSection.wxNum,
  PublishPageSection.newPrice,
  PublishPageSection.oldPrice,
];

class FocusNodeManager {
  FocusNodeManager() {
    _initFocusNode();
    _initController();
  }

  /// ## Getter
  bool get isInternalScroll => _isInternalScroll;

  /// ## Method
  FocusNode focusNodeOf(PublishPageSection section) {
    assert(section != null);
    return _sectionMapFocusNode[section];
  }

  TextEditingController controllerOf(PublishPageSection section) {
    assert(section != null);
    return _sectionMapController[section];
  }

  void unFocusAll() {
    _sectionMapFocusNode.values.forEach((FocusNode node) {
      node.unfocus();
    });
  }

  void dispose() {
    _sectionMapFocusNode.values.forEach((FocusNode node) {
      node.dispose();
    });
    _sectionMapController.values.forEach((TextEditingController controller) {
      controller.dispose();
    });
    _sectionMapFocusNode = null;
  }

  /// ## Internal
  Map<PublishPageSection, FocusNode> _sectionMapFocusNode;
  Map<PublishPageSection, TextEditingController> _sectionMapController;

  // Using this field to prevent internal scrolling unfocus textField
  bool _isInternalScroll = false;

  void _initFocusNode() {
    _sectionMapFocusNode = Map<PublishPageSection, FocusNode>.fromEntries(
      _focusNodeOwners.map<MapEntry<PublishPageSection, FocusNode>>(
        (PublishPageSection section) {
          final FocusNode focusNode = FocusNode(
            debugLabel: section.toString(),
          );
          focusNode.addListener(() {
            _focusListener(focusNode);
          });

          return MapEntry<PublishPageSection, FocusNode>(
            section,
            focusNode,
          );
        },
      ),
    );
  }

  void _initController() {
    _sectionMapController =
        Map<PublishPageSection, TextEditingController>.fromEntries(
      _focusNodeOwners.map<MapEntry<PublishPageSection, TextEditingController>>(
        (PublishPageSection section) {
          return MapEntry<PublishPageSection, TextEditingController>(
            section,
            TextEditingController(),
          );
        },
      ),
    );
  }

  Future<void> _focusListener(FocusNode focusNode) async {
    if (focusNode.hasFocus) {
      _isInternalScroll = true;

      /// Todo: Find a way to exactly get keyboard toggle event duration
      await Future.delayed(const Duration(milliseconds: 450));
      _isInternalScroll = false;
    }
  }
}
