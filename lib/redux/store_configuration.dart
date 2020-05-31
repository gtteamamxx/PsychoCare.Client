import 'package:psycho_care/redux/app/app_middleware.dart';
import 'package:psycho_care/redux/app/app_reducer.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/environment_groups/environments_groups_page_middleware.dart';
import 'package:psycho_care/redux/home/emotional_states/emotional_states_page_middleware.dart';
import 'package:psycho_care/redux/home/home_page_middleware.dart';
import 'package:psycho_care/redux/home/timeline/timeline_page_middleware.dart';
import 'package:psycho_care/redux/home/analysis/analysis_page_middleware.dart';
import 'package:psycho_care/redux/navigation/navigation_middleware.dart';
import 'package:psycho_care/redux/users/users_middleware.dart';
import 'package:redux/redux.dart';

Store<AppState> configureStore() {
  return Store<AppState>(
    appStateReducer,
    initialState: AppState.initial(),
    middleware: [
      appStateMiddleware,
      navigationMiddleware,
      usersMiddleware,
      homePageMiddleware,
      environmentGroupsPageMiddleware,
      emotionalStatesPageMiddleware,
      timelinePageMiddleware,
      analysisPageMiddleware,
    ],
  );
}
