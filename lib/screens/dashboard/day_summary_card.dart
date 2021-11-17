import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/models/last_day_summary.dart';
import 'package:pr2/screens/dashboard/sensor_data_row.dart';

class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard(this._lastDaySummary, {Key? key}) : super(key: key);

  final LastDaySummary _lastDaySummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('EEEE, MMMM d').format(_lastDaySummary.date),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 8.0),
            SensorDataRow(sensorValue: _lastDaySummary)
          ],
        ),
      ),
    );
  }
}
