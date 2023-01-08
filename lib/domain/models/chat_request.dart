import 'package:json_annotation/json_annotation.dart';

part 'chat_request.g.dart';

@JsonSerializable()
class ChatRequest {
  final String chatId;
  final int skip;
  final int take;

  ChatRequest({
    required this.chatId,
    required this.skip,
    required this.take,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);
}
