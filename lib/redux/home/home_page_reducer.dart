import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/redux/actions/home/change_home_page_action.dart';
import 'package:psycho_care/redux/actions/home/hide_action_button_action.dart';
import 'package:psycho_care/redux/actions/home/show_action_button_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/environment_groups/environments_groups_page_reducer.dart';
import 'package:psycho_care/redux/home/emotional_states/emotional_states_page_reducer.dart';
import 'package:psycho_care/redux/home/home_page_state.dart';
import 'package:psycho_care/redux/home/timeline/timeline_page_reducer.dart';
import 'package:psycho_care/redux/home/analysis/analysis_page_reducer.dart';

HomePageState homePageStateReducer(AppState state, dynamic action) {
  if (action is ChangeHomePageAction) {
    return state.homePageState.copyWith(selectedPage: action.page);
  } else if (action is ShowActionButtonAction) {
    return state.homePageState.copyWith(
      actionButtonIcon: Nullable(action.icon),
      actionButtonCallback: Nullable(action.onTap),
    );
  } else if (action is HideActionButtonAction) {
    return state.homePageState.copyWith(
      actionButtonCallback: Nullable(null),
      actionButtonIcon: Nullable(null),
    );
  }

  return state.homePageState.copyWith(
      environmentGroupsPageState: environmentsGroupsPageReducer(
          state.homePageState.environmentGroupsPageState, action),
      emotionalStatesPageState: emotionalStatesPageReducer(
          state.homePageState.emotionalStatesPageState, action),
      timelinePageState: timelinePageStateReducer(
          state.homePageState.timelinePageState, action),
      analysisPageState:
          analysisPageReducer(state.homePageState.analysisPageState, action));
}
