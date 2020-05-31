import 'package:flutter/material.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';

class EnvironmentGroupUIModel {
  final EnvironmentGroupModel group;
  final bool isEditing;

  EnvironmentGroupUIModel({this.group, this.isEditing});

  EnvironmentGroupUIModel copyWith({@required bool isEditing}) {
    return EnvironmentGroupUIModel(
      group: this.group,
      isEditing: isEditing,
    );
  }
}
