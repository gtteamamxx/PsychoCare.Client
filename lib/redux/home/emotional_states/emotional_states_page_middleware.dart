import 'package:fluttertoast/fluttertoast.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/add_emotional_state_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/clear_selection_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/fetch_environment_groups_for_add_state_action.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/set_environment_groups_for_add_state_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/http/emotional_states_service.dart';
import 'package:psycho_care/services/http/environment_groups_service.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';

void emotionalStatesPageMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is AddEmotionalStateAction) {
    _addEmotionalSate(store, action, next);
  } else if (action is FetchEnvironmentGroupsForAddStateAction) {
    _fetchEnvironmentGroups(store, next);
  } else {
    next(action);
  }
}

void _fetchEnvironmentGroups(Store<AppState> store, next) {
  EnvironmentGroupsService service = serviceLocator.get<EnvironmentGroupsService>();

  store.dispatch(ShowSpinnerAction());

  service.fetchEnvironmentGroups().then((List<EnvironmentGroupModel> groups) {
    store.dispatch(HideSpinnerAction());

    next(SetEnvironmentGrooupsForAddStateAction(groups));
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}

void _addEmotionalSate(Store<AppState> store, AddEmotionalStateAction action, NextDispatcher next) {
  EmotionalStatesService service = serviceLocator.get<EmotionalStatesService>();
  store.dispatch(ShowSpinnerAction());

  service.addEmotionalSate(action.emotionalState).then((_) {
    store.dispatch(HideSpinnerAction());
    next(ClearSelectionAction());

    Fluttertoast.showToast(msg: "Zarejestrowałeś swój stan :)");
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}
