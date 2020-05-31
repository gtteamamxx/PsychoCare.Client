import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/navigation/show_register_page_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_login_page_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/ui/common/wide_button.dart';

class WelcomeScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.welcome_screen_background_green_path),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                SvgPicture.asset(
                  Constants.logo_path,
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
                Text(
                  Constants.app_name,
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 35),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                WideButton(
                  title: "Zaloguj się",
                  background: Colors.transparent,
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(ShowLoginPageAction());
                  },
                ),
                SizedBox(height: 20),
                WideButton(
                  title: "Zarejestruj się",
                  background: Colors.white,
                  color: PsychoCareColors.primaryColor,
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(ShowRegisterPageAction());
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
