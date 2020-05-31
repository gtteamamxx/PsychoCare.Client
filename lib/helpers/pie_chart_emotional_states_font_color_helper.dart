import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';

class PieChartEmotionalStateFontColorsHelper {
  static TextStyleSpec getFontColorByState(EmotionalStatesEnum state) {
    switch (state) {
      case EmotionalStatesEnum.Bored:
        return TextStyleSpec(color: Color.black);
      default:
        return null;
    }
  }
}
