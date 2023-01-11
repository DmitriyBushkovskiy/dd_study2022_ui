import 'package:json_annotation/json_annotation.dart';

part 'renew_users_in_chat_request.g.dart';

@JsonSerializable()
class RenewUsersInChatRequest {
  final List<String> targetUsersId;
  final String chatId;

  RenewUsersInChatRequest({
    required this.targetUsersId,
    required this.chatId,
  });

  factory RenewUsersInChatRequest.fromJson(Map<String, dynamic> json) =>
      _$RenewUsersInChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RenewUsersInChatRequestToJson(this);
}
