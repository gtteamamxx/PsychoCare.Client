import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/helpers/emotional_states_occurences_count_helper.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/redux/actions/app/run_application_action.dart';
import 'package:psycho_care/redux/actions/home/analysis/set_emotional_states_occurrences_action.dart';
import 'package:psycho_care/redux/actions/home/profile/scan_qr_code_action.dart';
import 'package:psycho_care/redux/actions/home/profile/show_qr_code_action.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_emotional_states_at_timeline_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_home_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_other_user_info_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_welcome_screen_action.dart';
import 'package:psycho_care/redux/actions/spinner/hide_spinner_action.dart';
import 'package:psycho_care/redux/actions/spinner/show_spinner_action.dart';
import 'package:psycho_care/redux/actions/users/set_email_action.dart';
import 'package:psycho_care/redux/actions/users/set_token_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/http/emotional_states_service.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as qrScanner;

void appStateMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RunApplicationAction) {
    _getTokenFromPrefs().then((token) {
      _getEmailFromPrefs().then((email) {
        if (token.isEmpty) {
          next(ShowWelcomeScreenAction());
        } else {
          store.dispatch(SetTokenAction(token));
          if (email.isNotEmpty) {
            next(SetEmailAction(email));
          }
          next(ShowHomePageAction());
        }
      });
    });
  } else if (action is SetTokenAction) {
    _saveTokenInPrefs(action.token);
    _setAuthorizationToken(action.token);
    next(action);
  } else if (action is SetEmailAction) {
    _saveEmailInPrefs(action.email);
    next(action);
  } else if (action is ScanQrCodeAction) {
    _scanQrCode(store);
  } else if (action is ShowQRCodeAction) {
    _showQrCode(store, action.context);
  } else {
    next(action);
  }
}

_saveTokenInPrefs(String token) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(Constants.token_memory_key, token);
}

_saveEmailInPrefs(String email) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(Constants.email_memory_key, email);
}

_setAuthorizationToken(String token) {
  Dio dio = serviceLocator.get<Dio>();

  if (token == null) {
    dio.options.headers.remove("Authorization");
  } else {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}

Future<String> _getTokenFromPrefs() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constants.token_memory_key)) {
    return prefs.getString(Constants.token_memory_key);
  }

  return "";
}

Future<String> _getEmailFromPrefs() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(Constants.email_memory_key)) {
    return prefs.getString(Constants.email_memory_key);
  }

  return "";
}

_showQrCode(Store<AppState> store, BuildContext context) async {
  store.dispatch(ShowSpinnerAction());
  Uint8List result = await qrScanner.generateBarCode(store.state.token);
  store.dispatch(HideSpinnerAction());
  showDialog(
    context: context,
    child: Image.memory(result),
  );
}

_scanQrCode(Store<AppState> store) async {
  String token = await qrScanner.scan();

  if (token.isNotEmpty) {
    EmotionalStatesService service = serviceLocator.get<EmotionalStatesService>();

    store.dispatch(ShowSpinnerAction());

    service.fetchEmotionalStatesForUser(token).then((List<EmotionalStateModel> emotionalStates) {
      store.dispatch(HideSpinnerAction());

      Map<EmotionalStatesEnum, int> analysisPageOccurences = EmotionalStatesoccurencesCountHelper.countEmotionalStatesOccurrences(emotionalStates);
      store.dispatch(SetEmotionalStatesOccurrencesAction(analysisPageOccurences));
      store.dispatch(SetEmotionalStatesAtTimelineAction(emotionalStates));

      store.dispatch(ShowOtherUserInfoPageAction(emotionalStates: emotionalStates));
    }, onError: (_) {
      store.dispatch(HideSpinnerAction());
    });
  }
}
