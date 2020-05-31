import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/ui/home/other_user_home_page.dart';
import 'package:psycho_care/ui/register_user/register_user_page.dart';
import 'package:psycho_care/ui/login_user/login_user_page.dart';
import 'package:psycho_care/ui/welcome_screen/welcome_screen_page.dart';
import 'package:psycho_care/ui/home/home_page.dart';

Route<dynamic> routes(RouteSettings settings) {
  if (settings.name == "/") {
    return _showPage(Container());
  } else if (settings.name == "/welcome-screen") {
    return _showPage(WelcomeScreenPage());
  } else if (settings.name == "/register-user") {
    return _showPage(RegisterUserPage());
  } else if (settings.name == "/login-user") {
    return _showPage(LoginUserPage());
  } else if (settings.name == "/home") {
    return _showPage(HomePage());
  } else if (settings.name == "/user-info") {
    return _showPage(OtherUserHomePage(
      emotionalStates: settings.arguments as List<EmotionalStateModel>,
    ));
  }

  throw Exception("Route is not configured");
}

_showPage(Widget page) {
  return MaterialPageRoute(
    builder: (BuildContext context) {
      return page;
    },
  );
}
