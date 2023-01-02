// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_posts_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPostsRequestModel _$GetPostsRequestModelFromJson(
        Map<String, dynamic> json) =>
    GetPostsRequestModel(
      userId: json['userId'] as String?,
      lastPostDate: json['lastPostDate'] as String?,
      postsAmount: json['postsAmount'] as int,
    );

Map<String, dynamic> _$GetPostsRequestModelToJson(
        GetPostsRequestModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lastPostDate': instance.lastPostDate,
      'postsAmount': instance.postsAmount,
    };
