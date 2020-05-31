import 'package:json_annotation/json_annotation.dart';

part 'environment_group_model.g.dart';

@JsonSerializable()
class EnvironmentGroupModel {
  final int id;
  final String name;

  EnvironmentGroupModel({this.id = 0, this.name});

  factory EnvironmentGroupModel.fromJson(Map<String, dynamic> json) => _$EnvironmentGroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnvironmentGroupModelToJson(this);
}
