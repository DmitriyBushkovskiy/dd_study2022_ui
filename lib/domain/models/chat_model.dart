import 'package:dd_study2022_ui/domain/models/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  final String id;
  final String created;
  final String creatorId;
  final bool isPrivate;
  final MessageModel? lastMessage;

  ChatModel({
    required this.id,
    required this.created,
    required this.creatorId,
    required this.isPrivate,
    this.lastMessage,
  });

    factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
