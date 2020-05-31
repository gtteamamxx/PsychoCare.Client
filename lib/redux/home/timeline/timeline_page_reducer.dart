import 'package:psycho_care/redux/actions/home/timeline/set_emotional_states_at_timeline_action.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_from_action.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_to_action.dart';
import 'package:psycho_care/redux/home/timeline/timeline_page_state.dart';

TimelinePageState timelinePageStateReducer(TimelinePageState state, dynamic action) {
  if (action is SetEmotionalStatesAtTimelineAction) {
    return state.copyWith(
      emotionalStates: action.emotionalStates,
      from: _getValidFromDate(action),
    );
  } else if (action is SetFromAction) {
    return state.copyWith(from: action.from);
  } else if (action is SetToAction) {
    return state.copyWith(to: action.to);
  } else {
    return state;
  }
}

DateTime _getValidFromDate(SetEmotionalStatesAtTimelineAction action) {
  var now = DateTime.now();
  DateTime from = DateTime(now.year, now.month, now.day).subtract(Duration(days: 7));
  return from;
}
