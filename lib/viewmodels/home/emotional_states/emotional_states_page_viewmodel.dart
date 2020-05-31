import 'package:fluttertoast/fluttertoast.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/helpers/emotional_states_translations_helper.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/select_emotional_state_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/select_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/add_emotional_state_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/emotional_states/emotional_states_page_state.dart';
import 'package:redux/redux.dart';

typedef OnSateSelection = void Function(EmotionalStatesEnum state);
typedef OnEnvironmentGroupSelection = void Function(EnvironmentGroupModel group);
typedef OnAddEmotionalState = void Function(String comment);

class EmotionalStatesViewModel {
  final List<EnvironmentGroupModel> environmentGroups;
  final EnvironmentGroupModel selectedEnvironmentGroup;
  final EmotionalStatesEnum selectedEmotionalState;
  final OnSateSelection selectEmotionalState;
  final OnEnvironmentGroupSelection selectEnvironmentGroup;
  final OnAddEmotionalState addEmotionalState;
  final List<bool> isEmojiVisible;
  final bool isSpinnerVisible;

  EmotionalStatesViewModel({
    this.environmentGroups,
    this.selectedEnvironmentGroup,
    this.selectedEmotionalState,
    this.selectEmotionalState,
    this.selectEnvironmentGroup,
    this.addEmotionalState,
    this.isEmojiVisible,
    this.isSpinnerVisible,
  });

  static fromStore(Store<AppState> store) {
    EmotionalStatesPageState state = store.state.homePageState.emotionalStatesPageState;
    return EmotionalStatesViewModel(
      environmentGroups: state.environmentGroups,
      selectedEnvironmentGroup: state.selectedEnvironmentGroup,
      selectedEmotionalState: state.selectedEmotionalState,
      selectEmotionalState: (state) => onEmotionalStateSelection(store, state),
      selectEnvironmentGroup: (group) => onEnvironmentGroupSelection(store, group),
      addEmotionalState: (comment) => onAddEmotionalState(store, comment),
      isEmojiVisible: state.isEmojiVisible,
      isSpinnerVisible: store.state.isSpinnerVisible,
    );
  }

  static void onEmotionalStateSelection(Store<AppState> store, EmotionalStatesEnum state) {
    store.dispatch(SelectEmotionalStateAction(state));
    Fluttertoast.showToast(msg: "Wybrałeś: " + EmotionalStatesTranslationHelper.getTranslation(state));
  }

  static void onEnvironmentGroupSelection(Store<AppState> store, EnvironmentGroupModel group) {
    store.dispatch(SelectEnvironmentGroupAction(group));
  }

  static void onAddEmotionalState(Store<AppState> store, String comment) {
    EmotionalStatesPageState state = store.state.homePageState.emotionalStatesPageState;
    EmotionalStateModel stateToAdd = new EmotionalStateModel(
      state: state.selectedEmotionalState,
      environmentGroupId: state.selectedEnvironmentGroup.id,
      comment: comment?.trim() == '' ? null : comment?.trim(),
      creationDate: DateTime.now(),
    );

    store.dispatch(AddEmotionalStateAction(stateToAdd));
  }
}
