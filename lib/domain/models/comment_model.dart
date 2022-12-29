import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/models/comment.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  String id;
  String commentText;
  String created;
  bool changed;
  User author;
  int likes;
  bool likedByMe;
  final String? postId;

  CommentModel({
    required this.id,
    required this.commentText,
    required this.created,
    required this.changed,
    required this.author,
    required this.likes,
    required this.likedByMe,
    this.postId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  Comment toComment() {
    return Comment(
      id: id,
      commentText: commentText,
      created: created,
      changed: changed,
      likes: likes,
      likedByMe: likedByMe,
      authorId: author.id,
      postId: postId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentModel &&
      other.id == id &&
      other.commentText == commentText &&
      other.created == created &&
      other.changed == changed &&
      other.author == author &&
      other.likes == likes &&
      other.likedByMe == likedByMe &&
      other.postId == postId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      commentText.hashCode ^
      created.hashCode ^
      changed.hashCode ^
      author.hashCode ^
      likes.hashCode ^
      likedByMe.hashCode ^
      postId.hashCode;
  }

  CommentModel copyWith({
    String? id,
    String? commentText,
    String? created,
    bool? changed,
    User? author,
    int? likes,
    bool? likedByMe,
    String? postId,
  }) {
    return CommentModel(
      id: id ?? this.id,
      commentText: commentText ?? this.commentText,
      created: created ?? this.created,
      changed: changed ?? this.changed,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      postId: postId ?? this.postId,
    );
  }
}
