import 'package:json_annotation/json_annotation.dart';

part 'change_user_data_model.g.dart';

@JsonSerializable()
class ChangeUserDataModel {
  final DateTime birthDate;
  final String email;
  final String username;
  String? fullName;
  String? bio;
  String? phone;
  final bool privateAccount;

  ChangeUserDataModel({
    required this.birthDate,
    required this.email,
    required this.username,
    this.fullName,
    this.bio,
    this.phone,
    required this.privateAccount,
  });

    factory ChangeUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeUserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeUserDataModelToJson(this);
}
