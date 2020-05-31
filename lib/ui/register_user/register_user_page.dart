import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psycho_care/helpers/validator_helper.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/navigation/show_login_page_action.dart';
import 'package:psycho_care/redux/actions/users/register_user_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/ui/common/wide_button.dart';
import 'package:redux/redux.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                          SizedBox(height: 10),
                          Text("Powtórz hasło", style: Theme.of(context).textTheme.headline4),
                          TextFormField(
                            decoration: _textFieldDecoration(hintText: "••••••••"),
                            autovalidate: true,
                            obscureText: true,
                            validator: _validateRePassword,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  StoreProvider.of<AppState>(context).dispatch(ShowLoginPageAction(popCurrent: true));
                                },
                                child: Text(
                                  'Masz już konto? Zaloguj się',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  WideButton(
                    background: PsychoCareColors.primaryColor,
                    title: "Zarejestruj się",
                    onPressed: () {
                      _registerUser(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerUser(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    if (_formKey.currentState.validate() && !store.state.isSpinnerVisible) {
      store.dispatch(
        RegisterUserAction(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  String _passwordValidator(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(password)) {
      return "Hasło nie spełnia wymagań: długośc 8 znaków, 1 wielka litera, 1 mała litera, 1 znak specjalny i 1 liczba";
    }

    return null;
  }

  String _validateRePassword(String rePassword) {
    String password = _passwordController.text;

    if (password != null && rePassword != password) {
      return "Podane hasła nie są takie same";
    }

    return null;
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
}
