import 'package:dd_study2022_ui/domain/models/comment.dart';
import 'package:dd_study2022_ui/domain/models/post_content.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String id;
  String? description;
  String created;
  bool changed;
  int likes;
  User author;
  List<PostContent> postContent;
  List<Comment> comments;

  PostModel({
    required this.id,
    this.description,
    required this.created,
    required this.changed,
    required this.likes,
    required this.author,
    required this.postContent,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}