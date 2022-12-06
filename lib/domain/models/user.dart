import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String birthDate;
  final String? avatarLink;
  final int postsAmount;
  final int followedAmount;
  final int followersAmount;
  final bool privateAccount;
  final bool colorAvatar;

  User({
    required this.id,
    required this.username,
    required this.birthDate,
    this.avatarLink,
    required this.postsAmount,
    required this.followedAmount,
    required this.followersAmount,
    required this.privateAccount,
    required this.colorAvatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
