import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? bio;
  final String? phone;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.bio,
    this.phone,
  });

    factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
