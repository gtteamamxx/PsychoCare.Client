import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:psycho_care/other/psycho_care_colors.dart';
import 'package:psycho_care/redux/actions/home/timeline/fetch_emotional_states_action.dart';
import 'package:psycho_care/redux/app/app_state.dart';
import 'package:psycho_care/ui/common/chart_legend.dart';
import 'package:psycho_care/viewmodels/home/timeline/timeline_page_viewmodel.dart';

class TimelinePage extends StatelessWidget {
  final bool isStaticView;
  TimelinePage({this.isStaticView = false});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TimelinePageViewModel>(
      converter: (store) => TimelinePageViewModel.fromStore(store),
      onInit: (store) {
        if (!isStaticView) {
          store.dispatch(FetchEmotionalStatesAction());
        }
      },
      builder: (BuildContext context, TimelinePageViewModel viewModel) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Od: "),
                      _buildDatePicker(context, viewModel.from, (DateTime date) => viewModel.onDateFromSelected(date)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: <Widget>[
                      Text("Do: "),
                      _buildDatePicker(context, viewModel.to, (DateTime date) => viewModel.onDateToSelected(date)),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: BarChart(
                  viewModel.getSeries(),
                  animate: true,
                  domainAxis: new OrdinalAxisSpec(
                    renderSpec: SmallTickRendererSpec(
                      tickLengthPx: 5,
                      labelOffsetFromAxisPx: 2,
                      minimumPaddingBetweenLabelsPx: 10,
                      labelRotation: 25,
                    ),
                  ),
                  selectionModels: [
                    SelectionModelConfig(
                      type: SelectionModelType.info,
                      changedListener: (selectionInfo) => viewModel.onChartItemSelected(context, selectionInfo),
                    ),
                  ],
                  barGroupingType: BarGroupingType.stacked,
                  defaultRenderer: BarRendererConfig(
                    groupingType: BarGroupingType.stacked,
                    strokeWidthPx: 2,
                  ),
                  behaviors: [
                    PanAndZoomBehavior(),
                    SlidingViewport(),
                  ],
                ),
              ),
              ChartLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context, DateTime actualDate, DateSelected onDateSelected) {
    return FlatButton(
      color: PsychoCareColors.primaryColor,
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: actualDate,
          firstDate: DateTime(2020, 04),
          lastDate: DateTime.now(),
          locale: Locale("pl"),
        ).then((DateTime selectedDate) => onDateSelected(selectedDate));
      },
      child: Row(
        children: <Widget>[
          Text(DateFormat("yyyy.MM.dd").format(actualDate)),
          Icon(Icons.date_range),
        ],
      ),
    );
  }
}
