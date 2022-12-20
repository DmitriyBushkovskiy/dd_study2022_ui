import 'package:json_annotation/json_annotation.dart';

part 'register_user_request.g.dart';

@JsonSerializable()
class RegisterUserRequest {
  final String username;
  final String email;
  final String password;
  final String retryPassword;
  final DateTime birthDate;

  RegisterUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.retryPassword,
    required this.birthDate,
  });

    factory RegisterUserRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserRequestToJson(this);
}
