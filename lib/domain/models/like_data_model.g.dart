// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeDataModel _$LikeDataModelFromJson(Map<String, dynamic> json) =>
    LikeDataModel(
      likedByMe: json['likedByMe'] as bool,
      likesAmount: json['likesAmount'] as int,
    );

Map<String, dynamic> _$LikeDataModelToJson(LikeDataModel instance) =>
    <String, dynamic>{
      'likedByMe': instance.likedByMe,
      'likesAmount': instance.likesAmount,
    };
