import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psycho_care/helpers/validator_helper.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/navigation/show_register_page_action.dart';
import 'package:psycho_care/redux/actions/users/login_user_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/ui/common/wide_button.dart';
import 'package:redux/redux.dart';

class LoginUserPage extends StatefulWidget {
  @override
  _LoginUserPageState createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.dstATop,
              ),
              image: AssetImage(Constants.background_white_path),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: SvgPicture.asset(
                  Constants.logo_path,
                  width: 100,
                  height: 100,
                  color: PsychoCareColors.primaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("E-mail", style: Theme.of(context).textTheme.headline4),
                            TextFormField(
                              decoration: _textFieldDecoration(hintText: "marcin.nowak@gmail.com"),
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator,
                              controller: _emailController,
                            ),
                            SizedBox(height: 10),
                            Text("Hasło", style: Theme.of(context).textTheme.headline4),
                            TextFormField(
                              controller: _passwordController,
                              decoration: _textFieldDecoration(hintText: "••••••••"),
                              obscureText: true,
                              validator: _passwordValidator,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      StoreProvider.of<AppState>(context).dispatch(ShowRegisterPageAction(popCurrent: true));
                                    },
                                    child: Text(
                                      'Nie masz konta? Zarejestruj się',
                                      style: TextStyle(color: Colors.orange),
                                    )),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    WideButton(
                      background: PsychoCareColors.primaryColor,
                      title: "Zaloguj się",
                      onPressed: () {
                        _loginUser(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    if (_formKey.currentState.validate() && !store.state.isSpinnerVisible) {
      store.dispatch(LoginUserAction(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  InputDecoration _textFieldDecoration({String hintText}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsets.only(top: 7, bottom: 5),
      isDense: true,
      helperText: " ",
      errorMaxLines: 3,
    );
  }

  String _passwordValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Podaj hasło";
    } else if (value.length < 8) {
      return "Hasło jest nieprawidłowe";
    }

    return null;
  }
}
