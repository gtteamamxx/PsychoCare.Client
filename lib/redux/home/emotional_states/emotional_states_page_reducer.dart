import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/select_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/select_emotional_state_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/clear_selection_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/set_environment_groups_for_add_state_action.dart';
import 'package:psycho_care/redux/home/emotional_states/emotional_states_page_state.dart';

EmotionalStatesPageState emotionalStatesPageReducer(EmotionalStatesPageState state, dynamic action) {
  if (action is SelectEnvironmentGroupAction) {
    return state.copyWith(selectedEnvironmentGroup: Nullable(action.selectedGroup));
  } else if (action is SelectEmotionalStateAction) {
    return state.copyWith(selectedEmotionalState: Nullable(action.selectedEmotionalSate));
  } else if (action is SetEnvironmentGrooupsForAddStateAction) {
    return state.copyWith(
      environmentGroups: action.groups,
      selectedEnvironmentGroup: Nullable(action.groups.length > 0 ? action.groups.first : null),
    );
  } else if (action is ClearSelectionAction) {
    return state.copyWith(
      environmentGroups: state.environmentGroups,
      newIsEmojiVisible: new List.filled(EmotionalStatesEnum.values.length, true),
      selectedEmotionalState: Nullable(null),
      selectedEnvironmentGroup: Nullable(state.environmentGroups.length > 0 ? state.environmentGroups.first : null),
    );
  }

  return state;
}
