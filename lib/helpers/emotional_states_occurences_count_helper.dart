import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';

class EmotionalStatesoccurencesCountHelper {
  static Map<EmotionalStatesEnum, int> countEmotionalStatesOccurrences(List<EmotionalStateModel> emotionalStates) {
    Map<EmotionalStatesEnum, int> emotionalStatesOccurrences = new Map();
    emotionalStates.forEach((element) {
      if (emotionalStatesOccurrences[element.state] == null) {
        emotionalStatesOccurrences[element.state] = 1;
      } else {
        emotionalStatesOccurrences[element.state] += 1;
      }
    });
    return emotionalStatesOccurrences;
  }
}
