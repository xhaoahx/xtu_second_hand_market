import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:xtusecondhandmarket/logic/common/dispose_aware.dart';
import 'package:xtusecondhandmarket/logic/dao/comment.dart';
import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/logic/dao/user.dart';
import 'package:xtusecondhandmarket/test/details_model_test.dart';

export '../common/goods.dart';
export '../dao/goods_details.dart';
export '../dao/user.dart';

class DetailsPageModel with ChangeNotifier,DisposeAware{
  DetailsPageModel() {
    _commentFocusNode = FocusNode();
    _overlayKey = GlobalKey();
  }

  /// ## Getter
  User get publisher => _publisher;
  FullGoodsDetails get fullDetails => _fullDetails;
  bool get isLoadingPage => _isLoadingPage;
  String get commentContent => _commentContent;
  List<Comment> get comments => _comments;

  GlobalKey<OverlayState> get overlayKey => _overlayKey;
  ScrollController get scrollController => _scrollController;
  FocusNode get commentFocusNode => _commentFocusNode;

  /// ## Method
  Future<void> initPage(ShortGoodsDetails shortDetails) async {
    final int id = shortDetails.id;
    await Future.wait([
      loadFullDetails(id),
      loadPublisher(id),
      loadComment(id),
    ]);
    _isLoadingPage = false;
    notifyListeners();
  }

  Future<void> loadFullDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _fullDetails = yieldFullGoodsDetails(id);
  }

  Future<void> loadPublisher(int id) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _publisher = yieldPublisher(id);
  }

  Future<void> loadComment(int id) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _comments = yieldComments();
  }

  void showCommentTextField({WidgetBuilder builder}) {
    maybeRemoveCommentTextField();
    _commentTextField = OverlayEntry(builder: builder);
    _overlayKey.currentState.insert(_commentTextField);
  }

  void handleCommentInput(String value) {
    _commentContent = value;
  }

  void handleSentCommentTo(int userId) {}

  void showLikeAlert({WidgetBuilder builder}) {
    OverlayEntry overlayEntry = OverlayEntry(builder: builder);
    _overlayKey.currentState.insert(overlayEntry);
    Future.delayed(
      const Duration(
        milliseconds: 1500,
      ),
      () {
        overlayEntry.remove();
      },
    );
  }

  void maybeRemoveCommentTextField() {
    _commentFocusNode.unfocus();
    _commentTextField?.remove();
    _commentTextField = null;
  }

  static DetailsPageModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<DetailsPageModel>(context, listen: listen);

  @override
  void dispose() {
    super.dispose();
  }

  /// ## Internal
  ///
  ///
  User _publisher;
  FullGoodsDetails _fullDetails;
  List<Comment> _comments;
  bool _isLoadingPage = true;
  String _commentContent;

  FocusNode _commentFocusNode =
      FocusNode(debugLabel: 'comment textfield focus node');
  ScrollController _scrollController = ScrollController();
  GlobalKey<OverlayState> _overlayKey = GlobalKey();

  OverlayEntry _commentTextField;
}
