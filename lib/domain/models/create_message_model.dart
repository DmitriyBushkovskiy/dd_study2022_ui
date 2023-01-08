import 'package:json_annotation/json_annotation.dart';

part 'create_message_model.g.dart';

@JsonSerializable()
class CreateMessageModel {
  final String chatId;
  final String text;

  CreateMessageModel({
    required this.chatId,
    required this.text,
  });

    factory CreateMessageModel.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMessageModelToJson(this);
}
