import 'package:json_annotation/json_annotation.dart';

part 'change_post_description_model.g.dart';

@JsonSerializable()
class ChangePostDescriptionModel {
  final String postId;
  final String description;

  ChangePostDescriptionModel({
    required this.postId,
    required this.description,
  });

  factory ChangePostDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePostDescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePostDescriptionModelToJson(this);
}
