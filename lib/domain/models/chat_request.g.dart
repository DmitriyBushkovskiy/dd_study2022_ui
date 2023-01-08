// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
      chatId: json['chatId'] as String,
      skip: json['skip'] as int,
      take: json['take'] as int,
    );

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'skip': instance.skip,
      'take': instance.take,
    };
