import 'package:psycho_care/helpers/navigation_helper.dart';
import 'package:psycho_care/redux/actions/navigation/show_home_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_login_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_other_user_info_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_register_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_welcome_screen_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is ShowWelcomeScreenAction) {
    _showPage("/welcome-screen", initialPage: true);
  } else if (action is ShowRegisterPageAction) {
    _showPage("/register-user", popCurrent: action.popCurrent);
  } else if (action is ShowLoginPageAction) {
    _showPage("/login-user", popCurrent: action.popCurrent);
  } else if (action is ShowHomePageAction) {
    _showPage("/home", initialPage: true);
  } else if (action is ShowOtherUserInfoPageAction) {
    _showPage("/user-info", arguments: action.emotionalStates);
  } else {
    next(action);
  }
}

/*
  initialPage - when true it shows page and remove all hisory before
  popCurrent - removes current page and push new (replace)
*/
_showPage(String route, {bool popCurrent = false, bool initialPage = false, dynamic arguments}) {
  if (initialPage) {
    NavigationHelper.navigatorKey.currentState.pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
  } else if (popCurrent) {
    NavigationHelper.navigatorKey.currentState.popAndPushNamed(route, arguments: arguments);
  } else {
    NavigationHelper.navigatorKey.currentState.pushNamed(route, arguments: arguments);
  }
}
