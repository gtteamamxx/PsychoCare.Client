import 'package:psycho_care/enums/home_page_enum.dart';
import 'package:psycho_care/redux/actions/home/change_home_page_action.dart';
import 'package:psycho_care/redux/actions/home/init_home_page_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:redux/redux.dart';

void homePageMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is InitHomePageAction) {
    next(ChangeHomePageAction(HomePageEnum.EmotionalState));
  } else {
    next(action);
  }
}
