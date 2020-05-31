import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';

class EmotionalStateColorsHelper {
  static Color getColorByState(EmotionalStatesEnum state) {
    switch (state) {
      case EmotionalStatesEnum.Angry:
        return Color.fromARGB(255, 255, 76, 76);
      case EmotionalStatesEnum.Happy:
        return Color.fromARGB(255, 76, 154, 211);
      case EmotionalStatesEnum.Cheerful:
        return Color.fromARGB(255, 154, 109, 188);
      case EmotionalStatesEnum.Surprised:
        return Color.fromARGB(255, 76, 219, 76);
      case EmotionalStatesEnum.Bored:
        return Color.fromARGB(255, 255, 255, 76);
      case EmotionalStatesEnum.Sad:
        return Color.fromARGB(255, 255, 147, 76);
      default:
        return Colors.red;
    }
  }
}
