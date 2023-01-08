// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeUserDataModel _$ChangeUserDataModelFromJson(Map<String, dynamic> json) =>
    ChangeUserDataModel(
      birthDate: DateTime.parse(json['birthDate'] as String),
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String?,
      bio: json['bio'] as String?,
      phone: json['phone'] as String?,
      privateAccount: json['privateAccount'] as bool,
    );

Map<String, dynamic> _$ChangeUserDataModelToJson(
        ChangeUserDataModel instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate.toIso8601String(),
      'email': instance.email,
      'username': instance.username,
      'fullName': instance.fullName,
      'bio': instance.bio,
      'phone': instance.phone,
      'privateAccount': instance.privateAccount,
    };
