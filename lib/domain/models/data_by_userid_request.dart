import 'package:json_annotation/json_annotation.dart';

part 'data_by_userid_request.g.dart';

@JsonSerializable()
class DataByUserIdRequest {
  final String userId;
  final int skip;
  final int take;

  DataByUserIdRequest({
    required this.userId,
    required this.skip,
    required this.take,
  });

  factory DataByUserIdRequest.fromJson(Map<String, dynamic> json) =>
      _$DataByUserIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DataByUserIdRequestToJson(this);
}
