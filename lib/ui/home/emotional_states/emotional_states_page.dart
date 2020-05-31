import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psycho_care/helpers/emoji_cache_helper.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/enums/emotional_states_enum.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/redux/actions/home/emotional_states/fetch_environment_groups_for_add_state_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/viewmodels/home/emotional_states/emotional_states_page_viewmodel.dart';

class EmotionalStatesPage extends StatefulWidget {
  @override
  _EmotionalStatesPageState createState() => _EmotionalStatesPageState();
}

class _EmotionalStatesPageState extends State<EmotionalStatesPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<GifController> _animationControllers = new List<GifController>();
  final _addCommentController = new TextEditingController();

  @override
  void initState() {
    _initAnimationControllers();
    super.initState();
  }

  @override
  void dispose() {
    _disposeAnimationControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EmotionalStatesViewModel>(
      converter: (store) => EmotionalStatesViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(FetchEnvironmentGroupsForAddStateAction());
      },
      onDidChange: (viewModel) {
        if (viewModel.selectedEmotionalState == null) {
          _clearSelection(viewModel);
        }
      },
      builder: (context, viewModel) {
        return ListView(
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30),
                        Text(
                          "Stan emocjonalny",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Happy),
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Cheerful),
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Surprised),
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Bored),
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Sad),
                            _buildEmoji(viewModel, emotionalState: EmotionalStatesEnum.Angry)
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Grupa środowiskowa",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        _buildDropdownButton(viewModel),
                        SizedBox(height: 30),
                        Text(
                          "Opisz swój nastrój",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        TextFormField(
                          controller: _addCommentController,
                          maxLines: null,
                          style: TextStyle(fontSize: 18, fontStyle: FontStyle.normal, color: Colors.black),
                          decoration: _textFieldDecoration(hintText: " "),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildAcceptButton(viewModel),
                SizedBox(height: 30),
              ],
            ),
          ],
        );
      },
    );
  }

  double _setEmojiSize() {
    return (MediaQuery.of(context).size.width * 0.90) / EmotionalStatesEnum.values.length;
  }

  _buildEmoji(EmotionalStatesViewModel viewModel, {EmotionalStatesEnum emotionalState}) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () {
        _select(viewModel, emotionalState);
      },
      child: AnimatedOpacity(
        opacity: viewModel.isEmojiVisible[emotionalState.index] ? 1.0 : 0.2,
        duration: Duration(milliseconds: 500),
        child: GifImage(
          height: _setEmojiSize(),
          width: _setEmojiSize(),
          image: EmojiCacheHelper.emojis[emotionalState],
          controller: _animationControllers[emotionalState.index],
        ),
      ),
    );
  }

  _buildDropdownButton(viewModel) {
    return DropdownButton<EnvironmentGroupModel>(
      value: viewModel.selectedEnvironmentGroup,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 35,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (EnvironmentGroupModel group) {
        viewModel.selectEnvironmentGroup(group);
      },
      items: viewModel.environmentGroups.map<DropdownMenuItem<EnvironmentGroupModel>>((EnvironmentGroupModel group) {
        return DropdownMenuItem<EnvironmentGroupModel>(
          value: group,
          child: Text(
            group.name,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  _buildAcceptButton(vievModel) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 55,
      child: FlatButton(
        onPressed: () {
          _postState(vievModel);
        },
        color: PsychoCareColors.primaryColor,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.white),
        ),
        child: Text(
          'Zatwierdź',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _postState(vievModel) {
    if (vievModel.selectedEmotionalState != null && vievModel.selectedEnvironmentGroup != null) {
      vievModel.addEmotionalState(_addCommentController.text);
    } else if (vievModel.selectedEmotionalState == null) {
      Fluttertoast.showToast(
        msg: "Wybierz stan emocjonalny.",
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Wybierz grupę środowiskową.",
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void _select(EmotionalStatesViewModel viewModel, EmotionalStatesEnum emotionalSate) {
    for (var i = 0; i < EmotionalStatesEnum.values.length; i++) {
      if (i == emotionalSate.index) {
        _animationControllers[i].repeat(min: 1, max: 22, reverse: true);
      } else {
        _animationControllers[i].stop();
        _animationControllers[i].value = 0;
      }
    }

    viewModel.selectEmotionalState(emotionalSate);
  }

  void _clearSelection(viewModel) {
    if (!mounted) {
      return;
    }

    if (viewModel.isEmojiVisible.every((x) => x == true) && _animationControllers.every((x) => x.isAnimating)) {
      return;
    }

    for (var i = 0; i < EmotionalStatesEnum.values.length; i++) {
      _animationControllers[i].repeat(min: 1, max: 22, reverse: true);
    }

    _addCommentController.text = '';
  }

  void _initAnimationControllers() {
    for (var i = 0; i < EmotionalStatesEnum.values.length; i++) {
      _animationControllers.add(GifController(
        value: 1,
        vsync: this,
        duration: Duration(seconds: 1, milliseconds: 500),
      ));
      _animationControllers[i].repeat(min: 1, max: 22, reverse: true);
    }
  }

  void _disposeAnimationControllers() {
    for (var i = 0; i < EmotionalStatesEnum.values.length; i++) {
      _animationControllers[i].dispose();
    }
  }
}

InputDecoration _textFieldDecoration({String hintText}) {
  return InputDecoration(
    hintText: hintText,
    contentPadding: EdgeInsets.only(top: 7, bottom: 5),
    isDense: true,
    helperText: " ",
    errorMaxLines: 3,
  );
}
