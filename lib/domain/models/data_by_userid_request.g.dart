// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_by_userid_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataByUserIdRequest _$DataByUserIdRequestFromJson(Map<String, dynamic> json) =>
    DataByUserIdRequest(
      userId: json['userId'] as String,
      skip: json['skip'] as int,
      take: json['take'] as int,
    );

Map<String, dynamic> _$DataByUserIdRequestToJson(
        DataByUserIdRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'skip': instance.skip,
      'take': instance.take,
    };
