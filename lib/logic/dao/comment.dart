import 'package:json_annotation/json_annotation.dart';
import '../common/json_serializable.dart' as internal;
import 'user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment with internal.JsonSerializable{
  const Comment({
    this.content,
    this.commenter,
    this.depth,
    this.children = const [],
  });

  final String content;
  final User commenter;
  final int depth;
  final List<Comment> children;

  Map<String,dynamic> toJson() => _$CommentToJson(this);
  factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);
}
