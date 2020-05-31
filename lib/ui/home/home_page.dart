import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:psycho_care/enums/home_page_enum.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/home/init_home_page_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/ui/home/environment_groups/environment_groups_page.dart';
import 'package:psycho_care/ui/home/emotional_states/emotional_states_page.dart';
import 'package:psycho_care/ui/home/profile/profile_page.dart';
import 'package:psycho_care/ui/home/analysis/analysis_page.dart';
import 'package:psycho_care/ui/home/timeline/timeline_page.dart';
import 'package:psycho_care/viewmodels/home/home_page_viewmodel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = new PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      converter: (store) => HomePageViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(InitHomePageAction());
      },
      builder: (context, viewModel) {
        _buildNavigationItem({String title, IconData icon, HomePageEnum page}) {
          Color color = viewModel.selectedPage.index == page.index ? PsychoCareColors.secondaryColor : PsychoCareColors.primaryColor;

          return InkWell(
            onTap: () {
              _pageController.jumpToPage(page.index);
            },
            borderRadius: BorderRadius.circular(45),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, color: color),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
            resizeToAvoidBottomInset: true,
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                viewModel.getPageTitle(),
                style: Theme.of(context).textTheme.caption.copyWith(fontSize: 20),
              ),
            ),
            floatingActionButton: viewModel.actionButtonIcon != null
                ? FloatingActionButton(
                    onPressed: viewModel.onActionButtonTap,
                    backgroundColor: PsychoCareColors.secondaryColor,
                    child: Icon(
                      viewModel.actionButtonIcon,
                      size: 35,
                    ),
                  )
                : null,
            bottomNavigationBar: Material(
              shadowColor: Colors.black,
              color: Colors.white,
              child: Container(
                height: Constants.bottom_bar_height,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[6],
                    ),
                  ),
                  Container(
                    height: Constants.bottom_bar_height,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildNavigationItem(title: "Stan", icon: Icons.mood, page: HomePageEnum.EmotionalState),
                        _buildNavigationItem(title: "Grupy", icon: Icons.group, page: HomePageEnum.EnvironmentGroups),
                        _buildNavigationItem(title: "Profil", icon: Icons.account_circle, page: HomePageEnum.Profile),
                        _buildNavigationItem(title: "Analiza", icon: Icons.donut_small, page: HomePageEnum.Analysis),
                        _buildNavigationItem(title: "Oś", icon: Icons.timeline, page: HomePageEnum.Timeline),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            body: PageView(
              children: [
                EmotionalStatesPage(),
                EnvironmentGroupsPage(),
                ProfilePage(),
                AnalysisPage(),
                TimelinePage(),
              ],
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (pageIndex) {
                viewModel.onNavigationItemTap(HomePageEnum.values[pageIndex]);
              },
            ));
      },
    );
  }
}
