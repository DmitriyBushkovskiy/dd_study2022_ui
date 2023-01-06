import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study2022_ui/domain/enums/relation_state.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';

//part 'relation_state_model.g.dart';

//@JsonSerializable()
class RelationStateModel {
  final User targetUser;
  final RelationStateEnum relationAsFollower;
  final RelationStateEnum relationAsFollowed;

  RelationStateModel({
    required this.targetUser,
    required this.relationAsFollower,
    required this.relationAsFollowed,
  });

  factory RelationStateModel.fromJson(Map<String, dynamic> json) =>
      RelationStateModel(
        targetUser: User.fromJson(json['targetUser'] as Map<String, dynamic>),
        relationAsFollower: RelationStateEnum.values.firstWhere((e) =>
            e.toString() ==
            'RelationStateEnum.${(json['relationAsFollower'] as String).toLowerCase()}'),
        relationAsFollowed: RelationStateEnum.values.firstWhere((e) =>
            e.toString() ==
            'RelationStateEnum.${(json['relationAsFollowed'] as String).toLowerCase()}'),
      );

  Map<String, dynamic> toJson() => _$RelationStateModelToJson(this);

  Map<String, dynamic> _$RelationStateModelToJson(
          RelationStateModel instance) =>
      <String, dynamic>{
        'targetUser': instance.targetUser,
        'relationAsFollower': instance.relationAsFollower.toString(),
        'relationAsFollowed': instance.relationAsFollowed.toString(),
      };

  RelationStateModel copyWith({
    User? targetUser,
    RelationStateEnum? relationAsFollower,
    RelationStateEnum? relationAsFollowed,
  }) {
    return RelationStateModel(
      targetUser: targetUser ?? this.targetUser,
      relationAsFollower: relationAsFollower ?? this.relationAsFollower,
      relationAsFollowed: relationAsFollowed ?? this.relationAsFollowed,
    );
  }
}
