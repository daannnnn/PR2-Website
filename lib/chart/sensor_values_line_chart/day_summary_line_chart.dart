import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pr2/models/past_sensor_data.dart';

import 'line_chart_helper.dart';
import 'sensor_line_chart_bar_data.dart';
import 'sensor_value_format_helper.dart';
import 'sensor_value_spot.dart';

class DaySummaryLineChart extends StatefulWidget {
  DaySummaryLineChart({Key? key, required this.hourlyData}) : super(key: key) {
    try {
      if (Platform.isAndroid) {
        android = true;
      } else {
        android = false;
      }
      // ignore: empty_catches
    } catch (e) {
      android = false;
    }
  }

  final List<PastSensorData> hourlyData;

  late final bool android;

  @override
  State<StatefulWidget> createState() => _DaySummaryLineChartState();
}

class _DaySummaryLineChartState extends State<DaySummaryLineChart> {
  final airHumidityPoints = <SensorValueSpot>[];
  final airTemperaturePoints = <SensorValueSpot>[];
  final soilTemperaturePoints = <SensorValueSpot>[];
  final soilMoisturePoints = <SensorValueSpot>[];
  final lightPoints = <SensorValueSpot>[];

  final SensorValueFormatHelper _formatHelper = SensorValueFormatHelper();
  late LineChartHelper _chartHelper;

  @override
  void initState() {
    super.initState();
    _chartHelper = LineChartHelper(sensorValueFormatHelper: _formatHelper);

    final offset = DateTime.now().timeZoneOffset.inHours;
    final firstHour =
        ((((widget.hourlyData.first.hour + offset) / 24).floor() * 24) - offset)
            .toDouble();
    for (var element in widget.hourlyData) {
      airHumidityPoints.add(SensorValueSpot.ofAirHumidity(
          element.hour - firstHour, element.airHumidity));

      _formatHelper.updateTemperature(element.airTemperature);
      airTemperaturePoints.add(SensorValueSpot.ofAirTemperature(
          element.hour - firstHour,
          element.airTemperature,
          _formatHelper.maxTemp,
          _formatHelper.minTemp));

      _formatHelper.updateTemperature(element.soilTemperature);
      soilTemperaturePoints.add(SensorValueSpot.ofSoilTemperature(
          element.hour - firstHour,
          element.soilTemperature,
          _formatHelper.maxTemp,
          _formatHelper.minTemp));

      soilMoisturePoints.add(SensorValueSpot.ofSoilMoisture(
          element.hour - firstHour, element.soilMoisture));
      lightPoints.add(
          SensorValueSpot.ofLight(element.hour - firstHour, element.light));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.android ? (2 / 1) : (5 / 1),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 100,
                        minX: 0,
                        maxX: 23,
                        lineTouchData: _chartHelper.lineTouchData,
                        clipData: FlClipData.all(),
                        gridData: FlGridData(
                          show: false,
                          drawVerticalLine: false,
                        ),
                        lineBarsData: [
                          SensorLineChartBarData(
                              airHumidityPoints, Colors.blueAccent),
                          SensorLineChartBarData(
                              airTemperaturePoints, Colors.redAccent),
                          SensorLineChartBarData(
                              soilTemperaturePoints, Colors.greenAccent),
                          SensorLineChartBarData(
                              soilMoisturePoints, Colors.brown),
                          SensorLineChartBarData(
                              lightPoints, Colors.orangeAccent),
                        ],
                        titlesData: _chartHelper.titlesData,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
