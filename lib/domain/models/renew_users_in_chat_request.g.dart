// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renew_users_in_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenewUsersInChatRequest _$RenewUsersInChatRequestFromJson(
        Map<String, dynamic> json) =>
    RenewUsersInChatRequest(
      targetUsersId: (json['targetUsersId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$RenewUsersInChatRequestToJson(
        RenewUsersInChatRequest instance) =>
    <String, dynamic>{
      'targetUsersId': instance.targetUsersId,
      'chatId': instance.chatId,
    };
