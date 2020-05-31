import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/redux/actions/app/set_is_application_loading_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/actions/users/set_email_action.dart';
import 'package:psycho_care/redux/actions/users/set_token_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/home_page_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is ShowSpinnerAction) {
    return state.copyWith(isSpinnerVisible: true);
  } else if (action is HideSpinnerAction) {
    return state.copyWith(isSpinnerVisible: false);
  } else if (action is SetTokenAction) {
    return state.copyWith(token: Nullable(action.token));
  } else if (action is SetEmailAction) {
    return state.copyWith(email: Nullable(action.email));
  } else if (action is SetIsApplicationLoadingAction) {
    return state.copyWith(isApplicationLoading: action.newValue);
  }

  return state.copyWith(
    homePageState: homePageStateReducer(state, action),
  );
}
