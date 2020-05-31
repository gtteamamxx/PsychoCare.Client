import 'package:flutter/material.dart';
import 'package:psycho_care/enums/home_page_enum.dart';
import 'package:psycho_care/redux/actions/home/change_home_page_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/home_page_state.dart';
import 'package:redux/redux.dart';

typedef OnNavigationItemTap = void Function(HomePageEnum page);

class HomePageViewModel {
  final HomePageEnum selectedPage;
  final OnNavigationItemTap onNavigationItemTap;
  final VoidCallback onActionButtonTap;
  final IconData actionButtonIcon;

  HomePageViewModel({
    this.selectedPage,
    this.onNavigationItemTap,
    this.actionButtonIcon,
    this.onActionButtonTap,
  });

  static fromStore(Store<AppState> store) {
    HomePageState state = store.state.homePageState;

    return HomePageViewModel(
      selectedPage: state.selectedPage,
      onNavigationItemTap: (page) => store.dispatch(ChangeHomePageAction(page)),
      actionButtonIcon: state.actionButtonIcon,
      onActionButtonTap: state.actionButtonCallback,
    );
  }

  String getPageTitle() {
    switch (selectedPage) {
      case HomePageEnum.EmotionalState:
        return "Stan emocjonalny";
      case HomePageEnum.EnvironmentGroups:
        return "Grupy środowiskowe";
      case HomePageEnum.Profile:
        return "Profil użytkownika";
      case HomePageEnum.Analysis:
        return "Analiza";
      case HomePageEnum.Timeline:
        return "Oś czasu";
      default:
        return "";
    }
  }
}
