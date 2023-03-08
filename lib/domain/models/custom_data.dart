import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_data.g.dart';

@JsonSerializable()
class CustomData {
  final String? additionalProp1;
  final String? additionalProp2;
  final String? additionalProp3;

  CustomData({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory CustomData.fromJson(Map<String, dynamic> json) =>
      _$CustomDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomDataToJson(this);
}
