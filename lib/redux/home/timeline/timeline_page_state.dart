import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';

class TimelinePageState {
  final List<EmotionalStateModel> emotionalStates;
  final DateTime from;
  final DateTime to;

  TimelinePageState({
    this.emotionalStates,
    this.from,
    this.to,
  });

  TimelinePageState copyWith({
    List<EmotionalStateModel> emotionalStates,
    DateTime from,
    DateTime to,
  }) {
    return TimelinePageState(
      emotionalStates: emotionalStates ?? this.emotionalStates,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  static TimelinePageState initial() {
    var now = DateTime.now();

    return TimelinePageState(
      emotionalStates: [],
      from: now.subtract(Duration(days: 7)),
      to: DateTime(now.year, now.month, now.day),
    );
  }
}
