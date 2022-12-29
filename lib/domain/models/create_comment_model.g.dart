// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentModel _$CreateCommentModelFromJson(Map<String, dynamic> json) =>
    CreateCommentModel(
      postId: json['postId'] as String,
      commentText: json['commentText'] as String,
    );

Map<String, dynamic> _$CreateCommentModelToJson(CreateCommentModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'commentText': instance.commentText,
    };
