import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/db_model.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String? description;
  final String? authorId;
  final String created;
  final int likes;
  final bool likedByMe;
  final bool changed;

  Post({
    required this.id,
    this.description,
    this.authorId,
    required this.created,
    required this.likes,
    required this.likedByMe,
    required this.changed,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => Post(
      id: map['id'] as String,
      description: map['description'] as String?,
      authorId: map['authorId'] as String,
      created: map['created'] as String,
      likes: map['likes'] as int,
      likedByMe: (map['likedByMe'] as int) == 1,
      changed: (map['changed'] as int) == 1,
    );

  @override
  Map<String, dynamic> toMap() => _$PostToMap(this);

  Map<String, dynamic> _$PostToMap(Post instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'authorId': instance.authorId,
      'created': instance.created,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe? 1: 0,
      'changed': instance.changed? 1: 0,
    };

  Post copyWith({
    String? id,
    String? description,
    String? authorId,
    String? created,
    int? likes,
    bool? likedByMe,
    bool? changed,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      created: created ?? this.created,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      changed: changed ?? this.changed,
    );
  }
}
