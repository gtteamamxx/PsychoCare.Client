import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psycho_care/models/auth/auth_model.dart';
import 'package:psycho_care/redux/actions/navigation/show_login_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_home_page_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/actions/users/register_user_action.dart';
import 'package:psycho_care/redux/actions/users/login_user_action.dart';
import 'package:psycho_care/redux/actions/users/set_email_action.dart';
import 'package:psycho_care/redux/actions/users/set_token_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/http/users_service.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';

void usersMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RegisterUserAction) {
    _registerUser(action, store);
  } else if (action is LoginUserAction) {
    _loginUser(action, store);
  } else {
    next(action);
  }
}

_registerUser(RegisterUserAction action, Store<AppState> store) {
  String password = sha256.convert(utf8.encode(action.password)).toString();
  AuthModel authModel = AuthModel(action.email, password);

  store.dispatch(ShowSpinnerAction());

  UsersService usersService = serviceLocator.get<UsersService>();
  usersService.registerUser(authModel).then((_) {
    store.dispatch(HideSpinnerAction());
    Fluttertoast.showToast(msg: "Świetnie! teraz możesz się zalogować.");
    store.dispatch(ShowLoginPageAction(popCurrent: true));
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}

_loginUser(LoginUserAction action, Store<AppState> store) {
  String password = sha256.convert(utf8.encode(action.password)).toString();
  AuthModel authModel = AuthModel(action.email, password);

  store.dispatch(ShowSpinnerAction());

  UsersService usersService = serviceLocator.get<UsersService>();
  usersService.loginUser(authModel).then((token) {
    store.dispatch(HideSpinnerAction());

    if (token != null) {
      store.dispatch(SetTokenAction(token));
      store.dispatch(SetEmailAction(action.email));
      store.dispatch(ShowHomePageAction());
      Fluttertoast.showToast(msg: "Witaj!");
    }
  }, onError: (err) {
    store.dispatch(HideSpinnerAction());
  });
}
