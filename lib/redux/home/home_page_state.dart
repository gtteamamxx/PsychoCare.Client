import 'package:flutter/material.dart';
import 'package:psycho_care/enums/home_page_enum.dart';
import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/redux/home/emotional_states/emotional_states_page_state.dart';
import 'package:psycho_care/redux/home/environment_groups/environments_groups_page_state.dart';
import 'package:psycho_care/redux/home/timeline/timeline_page_state.dart';
import 'package:psycho_care/redux/home/analysis/analysis_page_state.dart';

class HomePageState {
  final HomePageEnum selectedPage;
  final VoidCallback actionButtonCallback;
  final IconData actionButtonIcon;

  final EnvironmentGroupsPageState environmentGroupsPageState;
  final EmotionalStatesPageState emotionalStatesPageState;
  final TimelinePageState timelinePageState;
  final AnalysisPageState analysisPageState;

  HomePageState({
    this.selectedPage,
    this.actionButtonCallback,
    this.actionButtonIcon,
    this.environmentGroupsPageState,
    this.emotionalStatesPageState,
    this.timelinePageState,
    this.analysisPageState,
  });

  HomePageState copyWith({
    HomePageEnum selectedPage,
    Nullable<VoidCallback> actionButtonCallback,
    Nullable<IconData> actionButtonIcon,
    EnvironmentGroupsPageState environmentGroupsPageState,
    EmotionalStatesPageState emotionalStatesPageState,
    TimelinePageState timelinePageState,
    AnalysisPageState analysisPageState,
  }) {
    return HomePageState(
      selectedPage: selectedPage ?? this.selectedPage,
      actionButtonCallback: actionButtonCallback == null
          ? this.actionButtonCallback
          : actionButtonCallback.data,
      actionButtonIcon: actionButtonIcon == null
          ? this.actionButtonIcon
          : actionButtonIcon.data,
      environmentGroupsPageState:
          environmentGroupsPageState ?? this.environmentGroupsPageState,
      emotionalStatesPageState:
          emotionalStatesPageState ?? this.emotionalStatesPageState,
      timelinePageState: timelinePageState ?? this.timelinePageState,
      analysisPageState: analysisPageState ?? this.analysisPageState,
    );
  }

  static HomePageState initial() {
    return HomePageState(
      selectedPage: HomePageEnum.Analysis,
      actionButtonCallback: null,
      actionButtonIcon: null,
      environmentGroupsPageState: EnvironmentGroupsPageState.initial(),
      emotionalStatesPageState: EmotionalStatesPageState.initial(),
      timelinePageState: TimelinePageState.initial(),
      analysisPageState: AnalysisPageState.initial(),
    );
  }
}
