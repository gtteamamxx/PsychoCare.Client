import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:psycho_care/helpers/emoji_cache_helper.dart';
import 'package:psycho_care/helpers/navigation_helper.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/app/run_application_action.dart';
import 'package:psycho_care/redux/actions/app/set_is_application_loading_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/services/routes.dart';
import 'package:psycho_care/services/service_locator.dart';
import 'package:redux/redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureServiceLocator();

  Store<AppState> store = serviceLocator.get<Store<AppState>>();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then(
        (_) => runApp(PsychoCareApp(store)),
      )
      .then(
        (_) async => await Future.delayed(Duration(), () {
          store.dispatch(RunApplicationAction());
        }),
      );
}

class PsychoCareApp extends StatelessWidget {
  final Store<AppState> store;
  PsychoCareApp(this.store);

  @override
  Widget build(BuildContext context) {
    _loadApplication(context);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: Constants.app_name,
        navigatorKey: NavigationHelper.navigatorKey,
        onGenerateRoute: routes,
        supportedLocales: [const Locale('pl')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          fontFamily: "Segoe UI",
          primaryColor: PsychoCareColors.primaryColor,
          textTheme: TextTheme(
            caption: TextStyle(color: Colors.white),
            headline4: TextStyle(
              color: PsychoCareColors.primaryColor,
              fontSize: 13,
            ),
          ),
        ),
        builder: (context, widget) {
          return StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, appState) {
              return WillPopScope(
                onWillPop: () => Future.value(!appState.isSpinnerVisible),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: appState.isApplicationLoading ? 1 : 0,
                      duration: Duration(milliseconds: 500),
                      child: Container(decoration: BoxDecoration(color: Colors.white)),
                    ),
                    AnimatedOpacity(
                      opacity: appState.isApplicationLoading ? 0 : 1,
                      duration: Duration(milliseconds: 300),
                      child: widget,
                    ),
                    appState.isSpinnerVisible || appState.isApplicationLoading ? _buildSpinnerCenter() : Container(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Center _buildSpinnerCenter() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          PsychoCareColors.secondaryColor,
        ),
      ),
    );
  }

  void _loadApplication(BuildContext context) {
    List<Future> futures = new List<Future>();
    EmojiCacheHelper.emojis.forEach((_, image) {
      futures.add(fetchGif(image));
    });

    Future.wait(futures).then((_) {
      store.dispatch(SetIsApplicationLoadingAction(false));
    });
  }
}
