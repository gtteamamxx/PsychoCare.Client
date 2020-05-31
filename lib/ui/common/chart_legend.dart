import 'package:flutter/material.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/helpers/emotional_state_colors_helper.dart';
import 'package:psycho_care/helpers/emotional_states_translations_helper.dart';

class ChartLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildLegend();
  }

  _buildLegend() {
    return Column(
      children: <Widget>[
        _buildLegendItem(EmotionalStatesEnum.Happy),
        _buildLegendItem(EmotionalStatesEnum.Cheerful),
        _buildLegendItem(EmotionalStatesEnum.Surprised),
        _buildLegendItem(EmotionalStatesEnum.Bored),
        _buildLegendItem(EmotionalStatesEnum.Sad),
        _buildLegendItem(EmotionalStatesEnum.Angry),
      ],
    );
  }

  _buildLegendItem(EmotionalStatesEnum state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 15,
            height: 15,
            color: EmotionalStateColorsHelper.getColorByState(state),
          ),
          SizedBox(width: 15),
          Text(EmotionalStatesTranslationHelper.getTranslation(state)),
        ],
      ),
    );
  }
}
