// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      commentText: json['commentText'] as String,
      created: json['created'] as String,
      changed: json['changed'] as bool,
      likes: json['likes'] as int,
      likedByMe: json['likedByMe'] as bool,
      authorId: json['authorId'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'commentText': instance.commentText,
      'created': instance.created,
      'changed': instance.changed,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe,
      'authorId': instance.authorId,
      'postId': instance.postId,
    };
