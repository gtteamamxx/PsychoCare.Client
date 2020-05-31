import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/models/environment_group/environment_group_ui_model.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/add_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/add_environment_group_to_add_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/delete_environment_group_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/disable_environment_group_editing_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/edit_environment_group_name_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/set_environment_group_editing_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/set_environment_groups_action.dart';
import 'package:psycho_care/redux/home/environment_groups/environments_groups_page_state.dart';

EnvironmentGroupsPageState environmentsGroupsPageReducer(EnvironmentGroupsPageState state, dynamic action) {
  if (action is AddEnvironmentGroupToAddAction) {
    /* W przypadku naciśnięcia przycisku dodania nowej grupy środowiskowej, dodajemy nową grupą 
       i ustawiamy flagę do edycji na true aby wyświetlić pole do edycji nazwy */
    List<EnvironmentGroupUIModel> groups = state.groups;

    var itemToAdd = EnvironmentGroupUIModel(isEditing: true, group: EnvironmentGroupModel());

    groups.add(itemToAdd);

    return state.copyWith(groups: groups);
  } else if (action is SetEnvironmentGroupEditingAction) {
    /* Jeśli naciśniemy edytuj przy jakiejkolwiek grupie środowiskowej
       ustawmy jej flagę do edycji na true aby wyświetlić pole do edycji nazwy */
    List<EnvironmentGroupUIModel> groups = state.groups;

    EnvironmentGroupUIModel itemToEdit = groups.firstWhere(
      (x) => x.group.id == action.groupToSetEditing.group.id,
      orElse: () => null,
    );

    groups[groups.indexOf(itemToEdit)] = itemToEdit.copyWith(isEditing: true);

    return state.copyWith(groups: groups);
  } else if (action is DisableEnvironmentGroupEditingAction) {
    List<EnvironmentGroupUIModel> groups = state.groups;

    EnvironmentGroupUIModel itemToEdit = groups.firstWhere(
      (x) => x.group.id == action.groupToDisableEditing.group.id,
      orElse: () => null,
    );

    groups[groups.indexOf(itemToEdit)] = itemToEdit.copyWith(isEditing: false);

    return state.copyWith(groups: groups);
  } else if (action is AddEnvironmentGroupAction) {
    /* Jeśli grupa środowiskowa została dodana do bazy danych, ustawiamy jej flagę do edycji na false, oraz 
       ustawiamy nowy model z ustawionym id aby schować pole do edycji nazwy */
    List<EnvironmentGroupUIModel> groups = state.groups;

    /* Dozwolona jest tylko edycja jednego elementu, więc obiekt który jest edytowany, jest naszym obiektem */
    EnvironmentGroupUIModel itemToEdit = groups.firstWhere(
      (x) => x.isEditing == true,
      orElse: () => null,
    );

    groups[groups.indexOf(itemToEdit)] = EnvironmentGroupUIModel(group: action.group, isEditing: false);

    return state.copyWith(groups: groups);
  } else if (action is SetEnvironmentGroupsAction) {
    List<EnvironmentGroupUIModel> groups = action.groups
        .map(
          (x) => EnvironmentGroupUIModel(group: x, isEditing: false),
        )
        .toList();

    return state.copyWith(groups: groups);
  } else if (action is DeleteEnvironmentGroupAction) {
    /* W przpyadku usunięcia danej grupy, musimy taką usunąc z kolekcji */
    List<EnvironmentGroupUIModel> groups = state.groups;

    groups.removeWhere((x) => x.group.id == action.environmentGroupId);

    return state.copyWith(groups: groups);
  } else if (action is EditEnvironmentGroupAction) {
    /* W przypadku edycji danej grupy, musimy podmienić cały model na ten, który jest w akcji, oraz 
       ustawić flagę do edycji na false */

    List<EnvironmentGroupUIModel> groups = state.groups;

    EnvironmentGroupUIModel itemToEdit = groups.firstWhere(
      (x) => x.isEditing == true,
      orElse: () => null,
    );

    groups[groups.indexOf(itemToEdit)] = EnvironmentGroupUIModel(group: action.group, isEditing: false);

    return state.copyWith(groups: groups);
  }

  return state;
}
