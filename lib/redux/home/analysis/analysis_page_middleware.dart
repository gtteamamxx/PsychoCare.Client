import 'package:psycho_care/helpers/emotional_states_occurences_count_helper.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/redux/actions/home/analysis/fetch_emotional_states_for_analysis_action.dart';
import 'package:psycho_care/redux/actions/home/analysis/set_emotional_states_occurrences_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/services/http/emotional_states_service.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';

void analysisPageMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is FetchEmotionalStatesForAnalysisAction) {
    _fetchEmotionalStates(store, action, next);
  } else {
    next(action);
  }
}

void _fetchEmotionalStates(Store<AppState> store, FetchEmotionalStatesForAnalysisAction action, NextDispatcher next) {
  EmotionalStatesService service = serviceLocator.get<EmotionalStatesService>();

  store.dispatch(ShowSpinnerAction());

  service.fetchEmotionalStates().then((List<EmotionalStateModel> emotionalStates) {
    Map<EmotionalStatesEnum, int> emotionalStatesOccurrences = EmotionalStatesoccurencesCountHelper.countEmotionalStatesOccurrences(emotionalStates);
    store.dispatch(HideSpinnerAction());

    next(SetEmotionalStatesOccurrencesAction(emotionalStatesOccurrences));
  }, onError: (_) {
    store.dispatch(HideSpinnerAction());
  });
}
