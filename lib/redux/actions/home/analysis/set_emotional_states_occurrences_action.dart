import 'package:psycho_care/enums/emotional_states_enum.dart';

class SetEmotionalStatesOccurrencesAction {
  final Map<EmotionalStatesEnum, int> emotionalStatesOccurrences;
  SetEmotionalStatesOccurrencesAction(this.emotionalStatesOccurrences);
}
