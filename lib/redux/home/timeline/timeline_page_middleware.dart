import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/redux/actions/home/timeline/fetch_emotional_states_action.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_emotional_states_at_timeline_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/http/emotional_states_service.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';

void timelinePageMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is FetchEmotionalStatesAction) {
    _fetchEmotionalStates(store, action, next);
  }
  next(action);
}

void _fetchEmotionalStates(Store<AppState> store, FetchEmotionalStatesAction action, NextDispatcher next) {
  EmotionalStatesService service = serviceLocator.get<EmotionalStatesService>();

  store.dispatch(ShowSpinnerAction());

  service.fetchEmotionalStates().then((List<EmotionalStateModel> emotionalStates) {
    store.dispatch(HideSpinnerAction());

    next(SetEmotionalStatesAtTimelineAction(emotionalStates));
  }, onError: (_) {
    store.dispatch(HideSpinnerAction());
  });
}
