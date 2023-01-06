import 'package:json_annotation/json_annotation.dart';

part 'search_users_request.g.dart';

@JsonSerializable()
class SearchUserRequest {
  final String username;
  final int skip;
  final int take;

  SearchUserRequest({
    required this.username,
    required this.skip,
    required this.take,
  });

  factory SearchUserRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUserRequestToJson(this);
}
