import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:psycho_care/redux/actions/home/profile/scan_qr_code_action.dart';
import 'package:psycho_care/redux/actions/home/profile/show_qr_code_action.dart';
import 'package:psycho_care/redux/actions/navigation/show_welcome_screen_action.dart';
import 'package:psycho_care/redux/actions/users/set_email_action.dart';
import 'package:psycho_care/redux/actions/users/set_token_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 180.0,
          ),
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                color: Colors.grey,
                size: 30.0,
              ),
              SizedBox(width: 16),
              Text(
                store.state.email ?? "",
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset(
                Constants.code_QR_path,
                width: 30,
                height: 30,
                color: Colors.grey,
              ),
              SizedBox(width: 16),
              InkWell(
                child: Text(
                  "Twój kod QR",
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  store.dispatch(ShowQRCodeAction(context));
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset(
                Constants.scan_QR_path,
                width: 30,
                height: 30,
                color: Colors.grey,
              ),
              SizedBox(width: 16),
              InkWell(
                child: Text(
                  "Skanuj kod QR",
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  store.dispatch(ScanQrCodeAction());
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Icon(
                Icons.exit_to_app,
                color: Colors.grey,
                size: 30.0,
              ),
              SizedBox(width: 16),
              InkWell(
                child: Text(
                  "Wyloguj",
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  store.dispatch(SetTokenAction(null));
                  store.dispatch(SetEmailAction(null));
                  store.dispatch(ShowWelcomeScreenAction());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
