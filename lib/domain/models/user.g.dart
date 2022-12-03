// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      birthDate: json['birthDate'] as String,
      avatarLink: json['avatarLink'] as String?,
      postsAmount: json['postsAmount'] as int,
      followedAmount: json['followedAmount'] as int,
      followersAmount: json['followersAmount'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'birthDate': instance.birthDate,
      'avatarLink': instance.avatarLink,
      'postsAmount': instance.postsAmount,
      'followedAmount': instance.followedAmount,
      'followersAmount': instance.followersAmount,
    };
