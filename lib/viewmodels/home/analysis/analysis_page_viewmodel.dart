import 'package:charts_flutter/flutter.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/models/emotional_states_occurrences/emotional_states_occurrences_model.dart';
import 'package:psycho_care/redux/home/analysis/analysis_page_state.dart';
import 'package:psycho_care/helpers/emotional_states_translations_helper.dart';
import 'package:psycho_care/helpers/emotional_state_colors_helper.dart';
import 'package:psycho_care/helpers/pie_chart_emotional_states_font_color_helper.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:redux/redux.dart';

class AnalysisPageViewModel {
  final Map<EmotionalStatesEnum, int> emotionalStatesOccurrences;
  final bool isSpinnerVisible;

  AnalysisPageViewModel({this.emotionalStatesOccurrences, this.isSpinnerVisible});

  static AnalysisPageViewModel fromStore(Store<AppState> store) {
    AnalysisPageState state = store.state.homePageState.analysisPageState;

    return AnalysisPageViewModel(
      emotionalStatesOccurrences: state.emotionalStatesOccurrences,
      isSpinnerVisible: store.state.isSpinnerVisible,
    );
  }

  List<Series<EmotionalStatesOccurrencesModel, String>> getSeries() {
    if (emotionalStatesOccurrences.length == 0) {
      return [];
    }

    List<EmotionalStatesOccurrencesModel> data = new List<EmotionalStatesOccurrencesModel>();
    emotionalStatesOccurrences.keys.forEach((element) {
      data.add(new EmotionalStatesOccurrencesModel(element, emotionalStatesOccurrences[element]));
    });

    List<Series<EmotionalStatesOccurrencesModel, String>> series = [
      Series<EmotionalStatesOccurrencesModel, String>(
        id: 'Analysis',
        domainFn: (EmotionalStatesOccurrencesModel data, _) => EmotionalStatesTranslationHelper.getTranslation(data.state),
        measureFn: (EmotionalStatesOccurrencesModel data, _) => data.occurrences,
        data: data,
        labelAccessorFn: (EmotionalStatesOccurrencesModel row, _) => '${EmotionalStatesTranslationHelper.getTranslation(row.state)}: ${row.occurrences}',
        colorFn: (EmotionalStatesOccurrencesModel row, _) => ColorUtil.fromDartColor(EmotionalStateColorsHelper.getColorByState(row?.state)),
        insideLabelStyleAccessorFn: (EmotionalStatesOccurrencesModel row, _) => PieChartEmotionalStateFontColorsHelper.getFontColorByState(row?.state),
      )
    ];
    return series;
  }
}
