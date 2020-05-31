import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/delete_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/edit_environment_group_name_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/fetch_environment_groups_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/set_environment_groups_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/http/environment_groups_service.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/add_environment_group_action.dart';

void environmentGroupsPageMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is FetchEnvironmentGroupsAction) {
    _fetchEnvironmentGroups(store, next);
  } else if (action is AddEnvironmentGroupAction) {
    _addEnvironmentGroup(store, action, next);
  } else if (action is DeleteEnvironmentGroupAction) {
    _deleteEnvironmentGroup(store, action, next);
  } else if (action is EditEnvironmentGroupAction) {
    _editEnvironmentGroup(store, action, next);
  } else {
    next(action);
  }
}

void _editEnvironmentGroup(Store<AppState> store, EditEnvironmentGroupAction action, next) {
  EnvironmentGroupsService service = serviceLocator.get<EnvironmentGroupsService>();

  store.dispatch(ShowSpinnerAction());

  service.editEnvironmentGroup(action.group).then((_) {
    store.dispatch(HideSpinnerAction());
    next(action);
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}

void _deleteEnvironmentGroup(Store<AppState> store, DeleteEnvironmentGroupAction action, next) {
  EnvironmentGroupsService service = serviceLocator.get<EnvironmentGroupsService>();

  store.dispatch(ShowSpinnerAction());

  service.deleteEnvironmentGroup(action.environmentGroupId).then((_) {
    store.dispatch(HideSpinnerAction());
    next(action);
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}

void _fetchEnvironmentGroups(Store<AppState> store, next) {
  EnvironmentGroupsService service = serviceLocator.get<EnvironmentGroupsService>();

  store.dispatch(ShowSpinnerAction());

  /*W przypadku pomyślnego pobrania grup środowiskowych dodajemy je do naszego stanu */
  service.fetchEnvironmentGroups().then((List<EnvironmentGroupModel> groups) {
    store.dispatch(HideSpinnerAction());

    next(SetEnvironmentGroupsAction(groups));
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}

void _addEnvironmentGroup(Store<AppState> store, AddEnvironmentGroupAction action, NextDispatcher next) {
  EnvironmentGroupsService service = serviceLocator.get<EnvironmentGroupsService>();

  store.dispatch(ShowSpinnerAction());

  /* W przypadku pomyślnego dodania nowej grupy, przesyłamy do reducera
    kopię akcji z przypisanym id grupy, któa została własnie dodana, aby nie wykonywać
    odświeżania wszystkich grup */

  service.addEnvironmentGroup(action.group).then((int id) {
    store.dispatch(HideSpinnerAction());

    next(AddEnvironmentGroupAction(EnvironmentGroupModel(id: id, name: action.group.name)));
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}
