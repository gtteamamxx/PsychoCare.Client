import 'package:psycho_care/models/environment_group/environment_group_ui_model.dart';

class EnvironmentGroupsPageState {
  final List<EnvironmentGroupUIModel> groups;

  EnvironmentGroupsPageState({this.groups});

  EnvironmentGroupsPageState copyWith({
    List<EnvironmentGroupUIModel> groups,
  }) {
    return EnvironmentGroupsPageState(
      groups: groups ?? this.groups,
    );
  }

  static EnvironmentGroupsPageState initial() {
    return EnvironmentGroupsPageState(
      groups: [],
    );
  }
}
