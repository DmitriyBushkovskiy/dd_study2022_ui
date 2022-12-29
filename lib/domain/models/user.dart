import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

import 'package:dd_study2022_ui/domain/db_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel {
  @override
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

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as String,
        username: map['username'] as String,
        birthDate: map['birthDate'] as String,
        avatarLink: map['avatarLink'] as String?,
        postsAmount: map['postsAmount'] as int,
        followedAmount: map['followedAmount'] as int,
        followersAmount: map['followersAmount'] as int,
        privateAccount: (map['privateAccount'] as int) == 1,
        colorAvatar: (map['colorAvatar'] as int) == 1,
      );

  @override
  Map<String, dynamic> toMap() => _$UserToMap(this);

  Map<String, dynamic> _$UserToMap(User instance) => <String, dynamic>{
        'id': instance.id,
        'username': instance.username,
        'birthDate': instance.birthDate,
        'avatarLink': instance.avatarLink,
        'postsAmount': instance.postsAmount,
        'followedAmount': instance.followedAmount,
        'followersAmount': instance.followersAmount,
        'privateAccount': instance.privateAccount ? 1 : 0,
        'colorAvatar': instance.colorAvatar ? 1 : 0,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.username == username &&
      other.birthDate == birthDate &&
      other.avatarLink == avatarLink &&
      other.postsAmount == postsAmount &&
      other.followedAmount == followedAmount &&
      other.followersAmount == followersAmount &&
      other.privateAccount == privateAccount &&
      other.colorAvatar == colorAvatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      birthDate.hashCode ^
      avatarLink.hashCode ^
      postsAmount.hashCode ^
      followedAmount.hashCode ^
      followersAmount.hashCode ^
      privateAccount.hashCode ^
      colorAvatar.hashCode;
  }

  User copyWith({
    String? id,
    String? username,
    String? birthDate,
    String? avatarLink,
    int? postsAmount,
    int? followedAmount,
    int? followersAmount,
    bool? privateAccount,
    bool? colorAvatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      birthDate: birthDate ?? this.birthDate,
      avatarLink: avatarLink ?? this.avatarLink,
      postsAmount: postsAmount ?? this.postsAmount,
      followedAmount: followedAmount ?? this.followedAmount,
      followersAmount: followersAmount ?? this.followersAmount,
      privateAccount: privateAccount ?? this.privateAccount,
      colorAvatar: colorAvatar ?? this.colorAvatar,
    );
  }
}
