// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    content: json['content'] as String,
    commenter: json['commenter'] == null
        ? null
        : User.fromJson(json['commenter'] as Map<String, dynamic>),
    depth: json['depth'] as int,
    children: (json['children'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'content': instance.content,
      'commenter': instance.commenter,
      'depth': instance.depth,
      'children': instance.children,
    };
