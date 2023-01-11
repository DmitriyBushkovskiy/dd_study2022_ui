// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as String,
      created: json['created'] as String,
      creatorId: json['creatorId'] as String,
      isPrivate: json['isPrivate'] as bool,
      name: json['name'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'creatorId': instance.creatorId,
      'isPrivate': instance.isPrivate,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'participants': instance.participants,
    };
