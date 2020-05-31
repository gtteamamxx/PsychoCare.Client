import 'package:psycho_care/redux/actions/home/analysis/set_emotional_states_occurrences_action.dart';
import 'package:psycho_care/redux/home/analysis/analysis_page_state.dart';

AnalysisPageState analysisPageReducer(AnalysisPageState state, dynamic action) {
  if (action is SetEmotionalStatesOccurrencesAction) {
    return state.copyWith(emotionalStatesOccurrences: action.emotionalStatesOccurrences);
  }

  return state;
}
