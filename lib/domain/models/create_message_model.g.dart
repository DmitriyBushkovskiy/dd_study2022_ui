// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMessageModel _$CreateMessageModelFromJson(Map<String, dynamic> json) =>
    CreateMessageModel(
      chatId: json['chatId'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$CreateMessageModelToJson(CreateMessageModel instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'text': instance.text,
    };
