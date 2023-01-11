import 'package:dd_study2022_ui/domain/enums/search_selection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_users_request.g.dart';

@JsonSerializable()
class SearchUserRequest {
  final String username;
  final int skip;
  final int take;
  final SearchSelectionEnum? selection;

  SearchUserRequest({
    required this.username,
    required this.skip,
    required this.take,
    this.selection
  });

  factory SearchUserRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUserRequestToJson(this);
}
