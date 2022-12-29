import 'package:json_annotation/json_annotation.dart';

part 'like_data_model.g.dart';

@JsonSerializable()
class LikeDataModel {
  final bool likedByMe;
  final int likesAmount;

  LikeDataModel({
    required this.likedByMe,
    required this.likesAmount,
  });

      factory LikeDataModel.fromJson(Map<String, dynamic> json) =>
      _$LikeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeDataModelToJson(this);
}
