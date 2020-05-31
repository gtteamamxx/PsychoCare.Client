// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotional_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionalStateModel _$EmotionalStateModelFromJson(Map<String, dynamic> json) {
  return EmotionalStateModel(
    id: json['id'] as int,
    state: _$enumDecodeNullable(_$EmotionalStatesEnumEnumMap, json['state']),
    environmentGroupId: json['environmentGroupId'] as int,
    comment: json['comment'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    environmentGroup: json['environmentGroup'] == null
        ? null
        : EnvironmentGroupModel.fromJson(
            json['environmentGroup'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EmotionalStateModelToJson(
        EmotionalStateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$EmotionalStatesEnumEnumMap[instance.state],
      'environmentGroupId': instance.environmentGroupId,
      'comment': instance.comment,
      'creationDate': instance.creationDate?.toIso8601String(),
      'environmentGroup': instance.environmentGroup,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EmotionalStatesEnumEnumMap = {
  EmotionalStatesEnum.Happy: 0,
  EmotionalStatesEnum.Cheerful: 1,
  EmotionalStatesEnum.Surprised: 2,
  EmotionalStatesEnum.Bored: 3,
  EmotionalStatesEnum.Sad: 4,
  EmotionalStatesEnum.Angry: 5,
};
