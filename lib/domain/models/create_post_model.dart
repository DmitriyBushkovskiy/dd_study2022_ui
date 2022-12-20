import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  final String description;
  final List<AttachMeta> content;

  CreatePostModel({
    required this.description,
    required this.content,
  });

    factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);
}