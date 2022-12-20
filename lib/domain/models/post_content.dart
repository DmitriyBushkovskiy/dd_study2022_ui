import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/db_model.dart';

part 'post_content.g.dart';

@JsonSerializable()
class PostContent implements DbModel {
  @override
  final String id;
  final String name;
  final String mimeType;
  final String contentLink;
  final String? postId;
  final int likes;
  final bool likedByMe;

  PostContent({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.contentLink,
    this.postId,
    required this.likes,
    required this.likedByMe,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) =>
      _$PostContentFromJson(json);

  Map<String, dynamic> toJson() => _$PostContentToJson(this);

  factory PostContent.fromMap(Map<String, dynamic> map) => PostContent(
        id: map['id'] as String,
        name: map['name'] as String,
        mimeType: map['mimeType'] as String,
        contentLink: map['contentLink'] as String,
        postId: map['postId'] as String,
        likes: map['likes'] as int,
        likedByMe: (map['likedByMe'] as int) == 1,
      );

  @override
  Map<String, dynamic> toMap() => _$PostContentToMap(this);

  Map<String, dynamic> _$PostContentToMap(PostContent instance) =>
      <String, dynamic>{
        'id': instance.id,
        'name': instance.name,
        'mimeType': instance.mimeType,
        'contentLink': instance.contentLink,
        'postId': instance.postId,
        'likes': instance.likes,
        'likedByMe': instance.likedByMe ? 1 : 0,
      };

  PostContent copyWith({
    String? id,
    String? name,
    String? mimeType,
    String? contentLink,
    String? postId,
    int? likes,
    bool? likedByMe,
  }) {
    return PostContent(
      id: id ?? this.id,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      contentLink: contentLink ?? this.contentLink,
      postId: postId ?? this.postId,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}
