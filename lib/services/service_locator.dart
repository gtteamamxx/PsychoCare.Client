import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/store_configuration.dart';
import 'package:psycho_care/services/http/emotional_states_service.dart';
import 'package:psycho_care/services/http/environment_groups_service.dart';
import 'package:psycho_care/services/http/users_service.dart';
import 'package:redux/redux.dart';

GetIt serviceLocator = GetIt.instance;

void configureServiceLocator() {
  Store<AppState> store = configureStore();

  Dio dio = Dio();
  dio.options.baseUrl = Constants.api_address;
  dio.options.headers["Content-Type"] = "application/json";
  dio.options.connectTimeout = 15000;
  dio.options.receiveTimeout = 15000;
  dio.options.sendTimeout = 15000;

  serviceLocator.registerSingleton<Store<AppState>>(store);
  serviceLocator.registerSingleton<Dio>(dio);
  serviceLocator.registerSingleton<UsersService>(UsersService());
  serviceLocator
      .registerSingleton<EnvironmentGroupsService>(EnvironmentGroupsService());
  serviceLocator
      .registerSingleton<EmotionalStatesService>(EmotionalStatesService());
}
