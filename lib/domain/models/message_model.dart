import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String authorId;
  final String text;
  final String created;
  final bool state;
  final User author;

  MessageModel({
    required this.id,
    required this.authorId,
    required this.text,
    required this.created,
    required this.state,
    required this.author,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
