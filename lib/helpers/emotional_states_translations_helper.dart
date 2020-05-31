import 'package:psycho_care/enums/emotional_states_enum.dart';

class EmotionalStatesTranslationHelper {
  static String getTranslation(EmotionalStatesEnum status) {
    switch (status) {
      case EmotionalStatesEnum.Happy:
        return "Szczęśliwy";
      case EmotionalStatesEnum.Cheerful:
        return "Wesoły";
      case EmotionalStatesEnum.Surprised:
        return "Zaskoczony";
      case EmotionalStatesEnum.Bored:
        return "Znudzony";
      case EmotionalStatesEnum.Sad:
        return "Smutny";
      case EmotionalStatesEnum.Angry:
        return "Zły";
      default:
        return "";
    }
  }
}
