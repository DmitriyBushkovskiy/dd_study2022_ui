import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/models/comment.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/post_content.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String id;
  String? description;
  String created;
  bool changed;
  int likes;
  bool likedByMe;
  User author;
  List<PostContent> postContent;
  List<CommentModel> comments;

  PostModel({
    required this.id,
    this.description,
    required this.created,
    required this.changed,
    required this.likes,
    required this.likedByMe,
    required this.author,
    required this.postContent,
    required this.comments,
  });

    static emptyPostModel() => PostModel(
    id: "",
    created: "",
    changed: false,
    likes: 0,
    likedByMe: false,
    postContent: <PostContent>[],
    comments: <CommentModel>[],
    author: User(
        id: "",
        username: "",
        birthDate: "",
        postsAmount: 0,
        followedAmount: 0,
        followersAmount: 0,
        privateAccount: true,
        colorAvatar: false));

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel copyWith({
    String? id,
    String? description,
    String? created,
    bool? changed,
    int? likes,
    bool? likedByMe,
    User? author,
    List<PostContent>? postContent,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      description: description ?? this.description,
      created: created ?? this.created,
      changed: changed ?? this.changed,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      author: author ?? this.author,
      postContent: postContent ?? this.postContent,
      comments: comments ?? this.comments,
    );
  }
}
