import 'package:flutter/material.dart';
import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';

class EmotionalStatesPageState {
  final List<EnvironmentGroupModel> environmentGroups;
  final EnvironmentGroupModel selectedEnvironmentGroup;
  final EmotionalStatesEnum selectedEmotionalState;
  final List<bool> isEmojiVisible;
  final List<AssetImage> imageCaches;

  EmotionalStatesPageState({
    this.selectedEnvironmentGroup,
    this.selectedEmotionalState,
    this.isEmojiVisible,
    this.environmentGroups,
    this.imageCaches,
  });

  EmotionalStatesPageState copyWith({
    Nullable<EnvironmentGroupModel> selectedEnvironmentGroup,
    Nullable<EmotionalStatesEnum> selectedEmotionalState,
    List<EnvironmentGroupModel> environmentGroups,
    List<bool> newIsEmojiVisible,
  }) {
    if (selectedEmotionalState?.data != null) {
      newIsEmojiVisible = new List.filled(EmotionalStatesEnum.values.length, false);
      newIsEmojiVisible[selectedEmotionalState.data.index] = true;
    }

    return EmotionalStatesPageState(
      selectedEnvironmentGroup: selectedEnvironmentGroup == null ? this.selectedEnvironmentGroup : selectedEnvironmentGroup.data,
      selectedEmotionalState: selectedEmotionalState == null ? this.selectedEmotionalState : selectedEmotionalState.data,
      isEmojiVisible: newIsEmojiVisible ?? this.isEmojiVisible,
      environmentGroups: environmentGroups ?? this.environmentGroups,
      imageCaches: this.imageCaches,
    );
  }

  static EmotionalStatesPageState initial() {
    return EmotionalStatesPageState(
      selectedEnvironmentGroup: null,
      selectedEmotionalState: null,
      isEmojiVisible: new List.filled(EmotionalStatesEnum.values.length, true),
      environmentGroups: [],
    );
  }
}
