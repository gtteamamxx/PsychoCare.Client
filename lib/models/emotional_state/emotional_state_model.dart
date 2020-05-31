import 'package:json_annotation/json_annotation.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';

part 'emotional_state_model.g.dart';

@JsonSerializable()
class EmotionalStateModel {
  final int id;
  final EmotionalStatesEnum state;
  final int environmentGroupId;
  final String comment;
  final DateTime creationDate;
  final EnvironmentGroupModel environmentGroup;

  EmotionalStateModel({
    this.id = 0,
    this.state,
    this.environmentGroupId,
    this.comment,
    this.creationDate,
    this.environmentGroup,
  });

  factory EmotionalStateModel.fromJson(Map<String, dynamic> json) => _$EmotionalStateModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmotionalStateModelToJson(this);
}
