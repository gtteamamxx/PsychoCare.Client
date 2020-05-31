import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/models/environment_group/environment_group_ui_model.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/add_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/delete_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/disable_environment_group_editing_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/edit_environment_group_name_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/set_environment_group_editing_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/environment_groups/environments_groups_page_state.dart';
import 'package:redux/redux.dart';

typedef OnItemAction = void Function(EnvironmentGroupUIModel item, String newName);
typedef OnItemDelete = void Function(EnvironmentGroupUIModel item);

class EnvironmentGroupsViewModel {
  final List<EnvironmentGroupUIModel> groups;
  final OnItemAction edit;
  final OnItemDelete delete;
  final bool isActionButtonVisible;
  final bool isSpinnerVisible;

  EnvironmentGroupsViewModel({
    this.groups,
    this.edit,
    this.delete,
    this.isActionButtonVisible,
    this.isSpinnerVisible,
  });

  static fromStore(Store<AppState> store) {
    EnvironmentGroupsPageState state = store.state.homePageState.environmentGroupsPageState;

    return EnvironmentGroupsViewModel(
      groups: state.groups,
      edit: (group, newName) => onGroupEdit(store, group, newName),
      delete: (group) => onGroupDelete(store, group),
      isActionButtonVisible: store.state.homePageState.actionButtonIcon != null,
      isSpinnerVisible: store.state.isSpinnerVisible,
    );
  }

  static void onGroupEdit(Store<AppState> store, EnvironmentGroupUIModel item, String newName) {
    /* W przypadku kiedy grupa środowiskowa jest w trakcie edycji, to znaczy, ze chcemy zmienić nazwę */
    if (item.isEditing) {
      /* Jeżeli obiekt ma id != 0 to znaczy, że pochodzi on z bazy danych, więc go edytujemy,
         w przeciwnym wypadku obiekt musimy dodać do bazy danych */
      if (item.group.id != 0) {
        if (item.group.name.toLowerCase() == newName.toLowerCase()) {
          store.dispatch(DisableEnvironmentGroupEditingAction(item));
        } else {
          store.dispatch(EditEnvironmentGroupAction(EnvironmentGroupModel(id: item.group.id, name: newName)));
        }
      } else {
        store.dispatch(AddEnvironmentGroupAction(EnvironmentGroupModel(name: newName)));
      }
    } else {
      /* W przypadku kiedy chcemy edytować jakąś grupę środowiskową musimy
        pokazać pole tekstowe do zmiany, czyli ustawić grupę jako edytowaną */
      store.dispatch(SetEnvironmentGroupEditingAction(item));
    }
  }

  static void onGroupDelete(Store<AppState> store, EnvironmentGroupUIModel item) {
    store.dispatch(DeleteEnvironmentGroupAction(item.group.id));
  }
}
