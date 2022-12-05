// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      bio: json['bio'] as String?,
      phone: json['phone'] as String?,
      privateAccount: json['privateAccount'] as bool,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'bio': instance.bio,
      'phone': instance.phone,
      'privateAccount': instance.privateAccount,
    };
