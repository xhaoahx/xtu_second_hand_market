import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xtusecondhandmarket/logic/model/details_page_model.dart';
import 'package:xtusecondhandmarket/logic/model/global_user_model.dart';
import 'package:xtusecondhandmarket/logic/model/theme_model.dart';
import '../../../logic/dao/comment.dart';

const double _avatarRadius = 20.0;
const double _kCommentTextFieldHeight = 52.0;

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget result = Selector<DetailsPageModel, bool>(
      builder: (BuildContext context, bool isLoading, Widget child) {
        return isLoading ? SliverFillRemaining() : CommentsContent(isLoading);
      },
      selector: (BuildContext context, DetailsPageModel model) {
        return model.isLoadingPage;
      },
    );

    return result;
  }
}

class CommentsContent extends StatefulWidget {
  const CommentsContent(this.isLoading);

  final bool isLoading;

  @override
  _CommentsContentState createState() => _CommentsContentState();
}

class _CommentsContentState extends State<CommentsContent> {
  @override
  Widget build(BuildContext context) {
    final List<Comment> comments = DetailsPageModel.of(context).comments;


    if (comments != null && comments.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if(index < comments.length){
            final Comment entry = comments[index];
            return _buildCommentEntry(entry);
          }else{
            // bigger than button size(56.0),let the last comment can be scroll above button
            return const SizedBox(height: 64.0,);
          }
        }, childCount: comments.length + 1),
      );
    } else {
      return SliverToBoxAdapter(
        child: Container(
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('宝贝还没有留言，快来问问卖家吧！'),
            ],
          ),
        )
      );
    }
  }

  Widget _buildCommentEntry(Comment entry) {
    Widget result;

    final Widget comment = ListTile(
      leading: Container(
        width: _avatarRadius * 2.0,
        height: _avatarRadius * 2.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              entry.commenter.avatarUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        entry.commenter.name,
      ),
      subtitle: Text(
        entry.content,
      ),
      onTap: (){
        _handleOnTap(entry.commenter.name);
      },
    );

    final List<Comment> children = entry.children;
    if (children != null && children.isNotEmpty) {
      result = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          comment,
          Padding(
            padding: EdgeInsets.only(
              left: (entry.depth + 1) * _avatarRadius * 2.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children.map<Widget>(_buildCommentEntry).toList(),
            ),
          ),
        ],
      );
    } else {
      result = comment;
    }

    return result;
  }

  void _handleOnTap(String name){
    final DetailsPageModel model =DetailsPageModel.of(context);
    model.showCommentTextField(
      builder: (BuildContext context) => CommentTextField(
        name
      ),
    );
  }
}


class CommentTextField extends StatelessWidget {
  const CommentTextField(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final DetailsPageModel model = DetailsPageModel.of(context);
    final GlobalUserModel userModel = GlobalUserModel.of(context);
    final ThemeData themeData = Theme.of(context);

    final Widget avatar = CircleAvatar(
      backgroundImage: NetworkImage(userModel.user.avatarUrl),
      radius: _kCommentTextFieldHeight * 0.35,
    );

    final Widget textField = TextField(
      autofocus: true,
      cursorColor: themeData.primaryColor,
      focusNode: model.commentFocusNode,
      onChanged: model.handleCommentInput,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(30)
      ],
      style: ThemeModel.of(context).fontData.h4_4,
      decoration: InputDecoration(
        hintText: '回复: @$name',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        hintMaxLines: 1,
      ),
    );

    final Widget sentButton = SizedBox(
      width: 60.0,
      child: FlatButton(
        padding: const EdgeInsets.all(0.0),
        color: themeData.primaryColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          '发送',
        ),
        onPressed: (){
          model.handleSentCommentTo(model.publisher.id);
        },
      ),
    );

    final Widget result = Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black45,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          avatar,
          Expanded(
            child: Padding(
              child:  textField,
              padding: const EdgeInsets.symmetric(horizontal: 7.0,),
            )
          ),
          sentButton
        ],
      ),
    );

    // This widget must be directly placed on overlay
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0.0,
      right: 0.0,
      height: _kCommentTextFieldHeight,
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details){
          _handleVerticalDrag(context,details);
        },
        child: result,
      ),
    );
  }

  void _handleVerticalDrag(BuildContext context,DragUpdateDetails details){
    if(details.delta.dy > 5.0){
      final DetailsPageModel model = DetailsPageModel.of(context);
      model.maybeRemoveCommentTextField();
    }
  }
}
