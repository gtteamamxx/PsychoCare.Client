import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:psycho_care/models/environment_group/environment_group_ui_model.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/add_environment_group_to_add_action.dart';
import 'package:psycho_care/redux/actions/home/environment_groups/fetch_environment_groups_action.dart';
import 'package:psycho_care/redux/actions/home/hide_action_button_action.dart';
import 'package:psycho_care/redux/actions/home/show_action_button_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/viewmodels/home/environment_groups/environment_groups_page_viewmodel.dart';
import 'package:redux/redux.dart';

class EnvironmentGroupsPage extends StatefulWidget {
  @override
  _EnvironmentGroupsPageState createState() => _EnvironmentGroupsPageState();
}

class _EnvironmentGroupsPageState extends State<EnvironmentGroupsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EnvironmentGroupsViewModel>(
      converter: (store) => EnvironmentGroupsViewModel.fromStore(store),
      onDidChange: (viewModel) {
        /* W przypadku, kiedy schowany został przycisk akcji na potrzeby edycji nazwy bądź
           dodawania nowej grupy i użytkownik już skończył edycję, pokażmy na nowo przycisk akcji
        */
        if (!viewModel.isActionButtonVisible && !viewModel.groups.any((x) => x.isEditing)) {
          Store<AppState> store = StoreProvider.of<AppState>(context);
          _showActionButton(store);
        }
      },
      onInit: (store) {
        store.dispatch(FetchEnvironmentGroupsAction());

        _showActionButton(store);
      },
      onDispose: (store) {
        store.dispatch(HideActionButtonAction());
      },
      builder: (builder, viewModel) {
        return Form(
          key: _formKey,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              EnvironmentGroupUIModel item = viewModel.groups[index];

              Widget groupWidget;
              if (item.isEditing) {
                groupWidget = _buildItemToEdit(item, viewModel);
              } else {
                groupWidget = _buildReadOnlyItem(item, viewModel);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: groupWidget,
              );
            },
            itemCount: viewModel.groups.length,
          ),
        );
      },
    );
  }

  void _showActionButton(Store<AppState> store) {
    store.dispatch(
      ShowActionButtonAction(
        icon: Icons.add,
        onTap: () {
          List<EnvironmentGroupUIModel> groups = store.state.homePageState.environmentGroupsPageState.groups;
          /* Pozwalamy na dodanie grupy tylko wtedy, kiedy
             a) pole formularza jest wypełnione
             b) nie ma już żadnego formularza (pozwalamy na edycję tylko jednej nazwy w tym samym czasie)
             c) nie wykonuje się żadne żądanie (kółeczko się nie kręci)
          */
          if (_formKey.currentState.validate() && !groups.any((x) => x.isEditing) && !store.state.isSpinnerVisible) {
            _nameController.text = "";
            store.dispatch(AddEnvironmentGroupToAddAction());
            store.dispatch(HideActionButtonAction());

            Future.delayed(Duration(milliseconds: 100), () {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              _focus.requestFocus();
            });
          }
        },
      ),
    );
  }

  Widget _buildItemToEdit(EnvironmentGroupUIModel item, EnvironmentGroupsViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            focusNode: _focus,
            autovalidate: true,
            decoration: _textFieldDecoration(hintText: "Wpisz nazwę grupy"),
            validator: _groupNameValidator,
            controller: _nameController,
          ),
        ),
        _buildActions(item, viewModel),
      ],
    );
  }

  Widget _buildReadOnlyItem(EnvironmentGroupUIModel item, EnvironmentGroupsViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            item.group.name,
            style: TextStyle(fontSize: 18),
          ),
        ),
        _buildActions(item, viewModel),
      ],
    );
  }

  Widget _buildActions(EnvironmentGroupUIModel item, EnvironmentGroupsViewModel viewModel) {
    Widget _buildAction(IconData icon, VoidCallback onTap) {
      return Flexible(
        child: Container(
          width: 35,
          height: 35,
          child: InkWell(
            borderRadius: BorderRadius.circular(45),
            onTap: onTap,
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          item.isEditing
              ? _buildAction(Icons.done, () {
                  if (_formKey.currentState.validate() && !viewModel.isSpinnerVisible) {
                    viewModel.edit(item, _nameController.text);
                  }
                })
              : Container(),
          item.isEditing
              ? Container()
              : _buildAction(Icons.delete, () {
                  if (!viewModel.isSpinnerVisible) {
                    viewModel.delete(item);
                  }
                }),
          item.isEditing
              ? Container()
              : _buildAction(Icons.edit, () {
                  if (!viewModel.isSpinnerVisible) {
                    _nameController.text = item.group.name;
                    viewModel.edit(item, _nameController.text);

                    Store<AppState> store = StoreProvider.of<AppState>(context);
                    store.dispatch(HideActionButtonAction());
                  }
                })
        ],
      ),
    );
  }

  InputDecoration _textFieldDecoration({String hintText}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsets.only(top: 7),
      helperText: " ",
      errorMaxLines: 2,
    );
  }

  String _groupNameValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Nazwa grupy musi posiadać nazwę";
    } else if (value.length > 64) {
      return "Maksymalna ilośc znaków to 64";
    } else if (value.length <= 3) {
      return "Wpisz nazwę grupy, która ma więcej niż 3 znaki";
    }

    return null;
  }
}
