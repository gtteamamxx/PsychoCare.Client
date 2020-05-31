import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:psycho_care/helpers/emoji_cache_helper.dart';
import 'package:psycho_care/helpers/emotional_states_translations_helper.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';

class TimelineDetailsPage extends StatefulWidget {
  final List<EmotionalStateModel> emotionalStates;

  TimelineDetailsPage(this.emotionalStates);

  @override
  _TimelineDetailsPageState createState() => _TimelineDetailsPageState();
}

class _TimelineDetailsPageState extends State<TimelineDetailsPage> with TickerProviderStateMixin {
  List<EmotionalStateModel> emotionalStates;
  final List<GifController> _animationControllers = new List<GifController>();

  @override
  void initState() {
    super.initState();
    emotionalStates = new List<EmotionalStateModel>()
      ..addAll(widget.emotionalStates)
      ..sort((x, y) => x.creationDate.isAfter(y.creationDate) ? 1 : -1);

    emotionalStates.forEach((EmotionalStateModel emotional) {
      var gifController = GifController(
        value: 1,
        vsync: this,
        duration: Duration(seconds: 1, milliseconds: 500),
      )..repeat(min: 1, max: 22, reverse: true);
      _animationControllers.add(gifController);
    });
  }

  @override
  void dispose() {
    _animationControllers.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text("Lista stanów emocjonalnych dla dnia"),
                  Text(
                    DateFormat("yyyy.MM.dd").format(emotionalStates[0].creationDate),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: this.emotionalStates.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.4),
                itemBuilder: (context, index) {
                  EmotionalStateModel emotionalState = this.emotionalStates[index];

                  return Card(
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (emotionalState.comment != null) {
                          Fluttertoast.showToast(msg: emotionalState.comment);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(DateFormat("HH:mm").format(emotionalState.creationDate)),
                                  ],
                                ),
                                GifImage(
                                  width: 45.0,
                                  height: 45.0,
                                  image: EmojiCacheHelper.emojis[emotionalState.state],
                                  excludeFromSemantics: true,
                                  controller: _animationControllers[index],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 20,
                                  child: Text(
                                    EmotionalStatesTranslationHelper.getTranslation(emotionalState.state),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(emotionalState.environmentGroup.name),
                            emotionalState.comment != null
                                ? Text(
                                    "Opis: " + emotionalState.comment,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
