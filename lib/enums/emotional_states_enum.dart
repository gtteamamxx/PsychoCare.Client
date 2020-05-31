import 'package:json_annotation/json_annotation.dart';

enum EmotionalStatesEnum {
  @JsonValue(0)
  Happy,
  @JsonValue(1)
  Cheerful,
  @JsonValue(2)
  Surprised,
  @JsonValue(3)
  Bored,
  @JsonValue(4)
  Sad,
  @JsonValue(5)
  Angry
}
