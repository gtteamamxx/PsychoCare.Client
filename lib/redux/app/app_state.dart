import 'package:psycho_care/helpers/nullable_class.dart';
import 'package:psycho_care/redux/home/home_page_state.dart';

class AppState {
  final bool isSpinnerVisible;
  final bool isApplicationLoading;
  final String token;
  final String email;

  final HomePageState homePageState;

  AppState({
    this.isSpinnerVisible,
    this.token,
    this.email,
    this.homePageState,
    this.isApplicationLoading,
  });

  static AppState initial() {
    return AppState(
      isSpinnerVisible: false,
      token: null,
      email: null,
      homePageState: HomePageState.initial(),
      isApplicationLoading: true,
    );
  }

  AppState copyWith({
    bool isSpinnerVisible,
    bool isApplicationLoading,
    Nullable<String> token,
    Nullable<String> email,
    HomePageState homePageState,
  }) {
    return AppState(
      isSpinnerVisible: isSpinnerVisible ?? this.isSpinnerVisible,
      token: token == null ? this.token : token.data,
      email: email == null ? this.email : email.data,
      homePageState: homePageState ?? this.homePageState,
      isApplicationLoading: isApplicationLoading ?? this.isApplicationLoading,
    );
  }
}
