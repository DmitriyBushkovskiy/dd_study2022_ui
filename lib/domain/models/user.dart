
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

  User({
    required this.id,
    required this.username,
    required this.birthDate,
    this.avatarLink,
    required this.postsAmount,
    required this.followedAmount,
    required this.followersAmount,
  });

    factory User.fromJson (Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson()=> _$UserToJson(this);
}
