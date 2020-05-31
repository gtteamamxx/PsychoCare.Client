import 'package:flutter/material.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';

class EmojiCacheHelper {
  static final Map<EmotionalStatesEnum, AssetImage> emojis = {
    EmotionalStatesEnum.Happy: AssetImage('assets/emoji/06.gif'),
    EmotionalStatesEnum.Angry: AssetImage('assets/emoji/02.gif'),
    EmotionalStatesEnum.Cheerful: AssetImage('assets/emoji/11.gif'),
    EmotionalStatesEnum.Surprised: AssetImage('assets/emoji/10.gif'),
    EmotionalStatesEnum.Bored: AssetImage('assets/emoji/09.gif'),
    EmotionalStatesEnum.Sad: AssetImage('assets/emoji/13.gif'),
  };
}
