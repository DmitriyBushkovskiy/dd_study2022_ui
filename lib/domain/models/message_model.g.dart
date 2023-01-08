// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      text: json['text'] as String,
      created: json['created'] as String,
      state: json['state'] as bool,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'text': instance.text,
      'created': instance.created,
      'state': instance.state,
      'author': instance.author,
    };
