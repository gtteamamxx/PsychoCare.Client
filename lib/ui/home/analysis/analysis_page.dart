import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:psycho_care/redux/actions/home/analysis/fetch_emotional_states_for_analysis_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/viewmodels/home/analysis/analysis_page_viewmodel.dart';

class AnalysisPage extends StatelessWidget {
  final bool isStaticView;
  AnalysisPage({this.isStaticView = false});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AnalysisPageViewModel>(
      converter: (store) => AnalysisPageViewModel.fromStore(store),
      onInit: (store) {
        if (!isStaticView) {
          store.dispatch(FetchEmotionalStatesForAnalysisAction());
        }
      },
      builder: (builder, viewModel) {
        return viewModel.isSpinnerVisible
            ? Container()
            : PieChart(viewModel.getSeries(),
                animate: true,
                defaultRenderer: ArcRendererConfig(
                  arcWidth: 100,
                  arcRendererDecorators: [ArcLabelDecorator()],
                ));
      },
    );
  }
}
