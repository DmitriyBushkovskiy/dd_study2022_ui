import 'package:json_annotation/json_annotation.dart';

part 'change_comment_model.g.dart';

@JsonSerializable()
class ChangeCommentModel {
  final String commentId;
  final String commentText;

  ChangeCommentModel({
    required this.commentId,
    required this.commentText,
  });

    factory ChangeCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeCommentModelToJson(this);
}
