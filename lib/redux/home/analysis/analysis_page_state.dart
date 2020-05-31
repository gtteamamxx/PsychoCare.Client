import 'package:psycho_care/enums/emotional_states_enum.dart';

class AnalysisPageState {
  final Map<EmotionalStatesEnum, int> emotionalStatesOccurrences;

  AnalysisPageState({this.emotionalStatesOccurrences});

  AnalysisPageState copyWith({Map<EmotionalStatesEnum, int> emotionalStatesOccurrences}) {
    return AnalysisPageState(emotionalStatesOccurrences: emotionalStatesOccurrences ?? this.emotionalStatesOccurrences);
  }

  static AnalysisPageState initial() {
    return AnalysisPageState(emotionalStatesOccurrences: new Map<EmotionalStatesEnum, int>());
  }
}
