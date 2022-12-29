// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      commentText: json['commentText'] as String,
      created: json['created'] as String,
      changed: json['changed'] as bool,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      likes: json['likes'] as int,
      likedByMe: json['likedByMe'] as bool,
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commentText': instance.commentText,
      'created': instance.created,
      'changed': instance.changed,
      'author': instance.author,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe,
      'postId': instance.postId,
    };
