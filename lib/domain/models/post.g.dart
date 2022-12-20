// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      description: json['description'] as String?,
      authorId: json['authorId'] as String?,
      created: json['created'] as String,
      likes: json['likes'] as int,
      likedByMe: json['likedByMe'] as bool,
      changed: json['changed'] as bool,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'authorId': instance.authorId,
      'created': instance.created,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe,
      'changed': instance.changed,
    };
