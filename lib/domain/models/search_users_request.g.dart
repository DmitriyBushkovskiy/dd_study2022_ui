// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_users_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserRequest _$SearchUserRequestFromJson(Map<String, dynamic> json) =>
    SearchUserRequest(
      username: json['username'] as String,
      skip: json['skip'] as int,
      take: json['take'] as int,
      selection:
          $enumDecodeNullable(_$SearchSelectionEnumEnumMap, json['selection']),
    );

Map<String, dynamic> _$SearchUserRequestToJson(SearchUserRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'skip': instance.skip,
      'take': instance.take,
      'selection': _$SearchSelectionEnumEnumMap[instance.selection],
    };

const _$SearchSelectionEnumEnumMap = {
  SearchSelectionEnum.avalable: 'avalable',
  SearchSelectionEnum.all: 'all',
};
