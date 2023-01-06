import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/db_model.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment implements DbModel {
  @override
  final String id;
  final String commentText;
  final String created;
  final bool changed;
  final int likes;
  final bool likedByMe;
  final String authorId;
  final String? postId;

  Comment({
    required this.id,
    required this.commentText,
    required this.created,
    required this.changed,
    required this.likes,
    required this.likedByMe,
    required this.authorId,
    this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
        id: map['id'] as String,
        commentText: map['commentText'] as String,
        created: map['created'] as String,
        changed: (map['changed'] as int) == 1,
        likes: map['likes'] as int,
        likedByMe: (map['likedByMe'] as int) == 1,
        authorId: map['authorId'] as String,
        postId: map['postId'] as String,
      );

  @override
  Map<String, dynamic> toMap() => _$CommentToMap(this);

  Map<String, dynamic> _$CommentToMap(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'commentText': instance.commentText,
      'created': instance.created,
      'changed': instance.changed? 1: 0,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe? 1: 0,
      'authorId': instance.authorId,
      'postId': instance.postId,
    };

  Comment copyWith({
    String? id,
    String? commentText,
    String? created,
    bool? changed,
    int? likes,
    bool? likedByMe,
    String? authorId,
    String? postId,
  }) {
    return Comment(
      id: id ?? this.id,
      commentText: commentText ?? this.commentText,
      created: created ?? this.created,
      changed: changed ?? this.changed,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      authorId: authorId ?? this.authorId,
      postId: postId ?? this.postId,
    );
  }
}
