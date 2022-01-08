import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/chart/sensor_values_line_chart/realtime_values_line_chart.dart';
import 'package:pr2/models/current.dart';
import 'realtime_data_cards.dart';

class RealtimeData extends StatefulWidget {
  const RealtimeData({
    Key? key,
    required this.stream,
    required this.intervalSeconds,
    required this.pastMinuteValueToShow,
  }) : super(key: key);

  final Stream<Current>? stream;
  final int intervalSeconds;
  final int pastMinuteValueToShow;

  @override
  State<StatefulWidget> createState() => _RealtimeDataState();
}

class _RealtimeDataState extends State<RealtimeData> {
  final RealtimeValuesLineChartController controller =
      RealtimeValuesLineChartController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, snapshot) {
          Current current = Current.empty();
          if (snapshot.hasData) {
            current = snapshot.data as Current;
            controller.add(current);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Last update time: ${DateFormat.jms().format(DateTime.fromMillisecondsSinceEpoch(current.seconds.toInt() * 1000))}"
                    .toUpperCase(),
                style: Theme.of(context).textTheme.overline,
              ),
              const SizedBox(height: 16.0),
              RealtimeDataCards(
                current: current,
                controller: controller,
              ),
              const SizedBox(height: 24.0),
              Text(
                "Past ${widget.pastMinuteValueToShow} ${widget.pastMinuteValueToShow == 1 ? 'minute' : 'minutes'}"
                    .toUpperCase(),
                style: Theme.of(context).textTheme.overline,
                textAlign: TextAlign.center,
              ),
              RealtimeValuesLineChart(
                  intervalSeconds: widget.intervalSeconds,
                  pastMinuteValueToShow: widget.pastMinuteValueToShow,
                  controller: controller),
            ],
          );
        });
  }
}
