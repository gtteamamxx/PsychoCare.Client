import 'package:flutter/material.dart';
import 'package:psycho_care/enums/home_page_enum.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/other/constants.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/ui/home/analysis/analysis_page.dart';
import 'package:psycho_care/ui/home/timeline/timeline_page.dart';

class OtherUserHomePage extends StatefulWidget {
  final List<EmotionalStateModel> emotionalStates;

  OtherUserHomePage({@required this.emotionalStates});

  @override
  _OtherUserHomePageState createState() => _OtherUserHomePageState();
}

class _OtherUserHomePageState extends State<OtherUserHomePage> {
  final PageController _pageController = new PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildNavigationItem({String title, IconData icon, HomePageEnum page}) {
      int pageIndex = (page.index - 3);

      Color color = PsychoCareColors.primaryColor;
      if (!_pageController.hasClients && pageIndex == 0) {
        color = PsychoCareColors.secondaryColor;
      } else if (!_pageController.hasClients) {
        color = PsychoCareColors.primaryColor;
      } else if (_pageController.page == pageIndex) {
        color = PsychoCareColors.secondaryColor;
      }

      return InkWell(
        onTap: () {
          _pageController.jumpToPage(pageIndex);
          setState(() {});
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Inny użytkownik",
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 20),
        ),
      ),
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
          AnalysisPage(isStaticView: true),
          TimelinePage(isStaticView: true),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
      ),
    );
  }
}
