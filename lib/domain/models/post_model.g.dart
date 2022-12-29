// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      description: json['description'] as String?,
      created: json['created'] as String,
      changed: json['changed'] as bool,
      likes: json['likes'] as int,
      likedByMe: json['likedByMe'] as bool,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      postContent: (json['postContent'] as List<dynamic>)
          .map((e) => PostContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'created': instance.created,
      'changed': instance.changed,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe,
      'author': instance.author,
      'postContent': instance.postContent,
      'comments': instance.comments,
    };
