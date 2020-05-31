import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:psycho_care/helpers/emotional_state_colors_helper.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_from_action.dart';
import 'package:psycho_care/redux/actions/home/timeline/set_to_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/redux/home/timeline/timeline_page_state.dart';
import 'package:psycho_care/ui/home/timeline/timeline_details_page.dart';
import 'package:redux/redux.dart';
import "package:collection/collection.dart";

typedef DateSelected = void Function(DateTime date);
typedef ChartItemSelected = void Function(BuildContext context, SelectionModel<String> selectionInfo);

class TimelinePageViewModel {
  final List<EmotionalStateModel> emotionalStates;
  final DateTime from;
  final DateTime to;
  final DateSelected onDateFromSelected;
  final DateSelected onDateToSelected;
  final ChartItemSelected onChartItemSelected;

  TimelinePageViewModel({
    this.emotionalStates,
    this.from,
    this.to,
    this.onDateFromSelected,
    this.onDateToSelected,
    this.onChartItemSelected,
  });

  static TimelinePageViewModel fromStore(Store<AppState> store) {
    TimelinePageState state = store.state.homePageState.timelinePageState;

    return TimelinePageViewModel(
      emotionalStates: state.emotionalStates,
      from: state.emotionalStates.length == 0 ? _getNowByDaysDateTime() : state.from,
      to: state.emotionalStates.length == 0 ? _getNowByDaysDateTime() : state.to,
      onChartItemSelected: (context, selectionInfo) => _onChartItemClick(context, selectionInfo),
      onDateFromSelected: (date) {
        if (_isDateRangeValid(date, state.to)) {
          store.dispatch(SetFromAction(date));
        }
      },
      onDateToSelected: (date) {
        if (_isDateRangeValid(state.from, date)) {
          store.dispatch(SetToAction(date));
        }
      },
    );
  }

  List<Series<EmotionalStateModel, String>> getSeries() {
    if (emotionalStates.length == 0) {
      return [];
    }

    Map<int, DateTime> dates = new Map<int, DateTime>();
    Map<int, List<EmotionalStateModel>> itemsPerKeys = new Map<int, List<EmotionalStateModel>>();

    _calculateSeriesDictionaries(dates, itemsPerKeys);
    _setSeriesItemsByEmotionalStates(dates, itemsPerKeys);

    List<Series<EmotionalStateModel, String>> result = _mapDictionariesToSeries(itemsPerKeys, dates);

    return result;
  }

  List<Series<EmotionalStateModel, String>> _mapDictionariesToSeries(Map<int, List<EmotionalStateModel>> itemsPerKeys, Map<int, DateTime> dates) {
    List<Series<EmotionalStateModel, String>> result = [];

    itemsPerKeys.forEach((key, items) {
      var item = Series<EmotionalStateModel, String>(
        id: key.toString(),
        domainFn: (__, _) => DateFormat("dd.MM").format(dates[key]),
        measureFn: (EmotionalStateModel model, _) => model == null ? 0 : 1,
        data: items.length == 0 ? [null] : items,
        colorFn: (EmotionalStateModel model, _) => ColorUtil.fromDartColor(EmotionalStateColorsHelper.getColorByState(model?.state)),
      );

      result.add(item);
    });

    return result;
  }

  void _setSeriesItemsByEmotionalStates(Map<int, DateTime> dates, Map<int, List<EmotionalStateModel>> itemsPerKeys) {
    Map<int, List<EmotionalStateModel>> mapYear = groupBy<EmotionalStateModel, int>(emotionalStates, (x) => x.creationDate.year);

    mapYear.forEach((int year, List<EmotionalStateModel> yearItems) {
      Map<int, List<EmotionalStateModel>> mapMonth = groupBy<EmotionalStateModel, int>(yearItems, (x) => x.creationDate.month);

      mapMonth.forEach((int month, List<EmotionalStateModel> monthItems) {
        Map<int, List<EmotionalStateModel>> mapDays = groupBy<EmotionalStateModel, int>(monthItems, (x) => x.creationDate.day);

        mapDays.forEach((int day, List<EmotionalStateModel> dayItems) {
          dayItems.sort((x, y) => x.state.index < y.state.index ? 1 : -1);

          int key = int.parse(_doubleCharPrecission(year) + _doubleCharPrecission(month) + _doubleCharPrecission(day));
          if (!dates.containsKey(key)) return;

          itemsPerKeys[key] = dayItems;
        });
      });
    });
  }

  void _calculateSeriesDictionaries(Map<int, DateTime> dates, Map<int, List<EmotionalStateModel>> itemsPerKeys) {
    DateTime actual = this.from;
    while (actual.isBefore(this.to) || actual.isAtSameMomentAs(this.to)) {
      int key = int.parse("${_doubleCharPrecission(actual.year)}${_doubleCharPrecission(actual.month)}${_doubleCharPrecission(actual.day)}");

      dates[key] = new DateTime(actual.year, actual.month, actual.day);
      itemsPerKeys[key] = [];

      actual = actual.add(Duration(days: 1));
    }
  }

  String _doubleCharPrecission(int v) {
    return v < 10 ? '0' + v.toString() : v.toString();
  }

  static void _onChartItemClick(BuildContext context, SelectionModel<String> selectionInfo) {
    if (selectionInfo?.selectedSeries?.length == null || selectionInfo?.selectedSeries?.length == 0) {
      return;
    }

    List<EmotionalStateModel> emotionalStates = selectionInfo.selectedSeries[0]?.data?.cast<EmotionalStateModel>();
    showDialog(
      context: context,
      child: TimelineDetailsPage(emotionalStates),
    );
  }

  static bool _isDateRangeValid(DateTime from, DateTime to) {
    if (to.isBefore(from)) {
      Fluttertoast.showToast(msg: "Data do nie może być wcześniejsza niż data od");
      return false;
    } else if (to.difference(from).inDays.abs() > 10) {
      Fluttertoast.showToast(msg: "Maksymalny przedział wynosi 10 dni");
      return false;
    }

    return true;
  }

  static DateTime _getNowByDaysDateTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
