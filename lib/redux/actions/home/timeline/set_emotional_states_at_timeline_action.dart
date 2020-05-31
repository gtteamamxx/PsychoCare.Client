import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';

class SetEmotionalStatesAtTimelineAction {
  final List<EmotionalStateModel> emotionalStates;
  SetEmotionalStatesAtTimelineAction(this.emotionalStates);
}
