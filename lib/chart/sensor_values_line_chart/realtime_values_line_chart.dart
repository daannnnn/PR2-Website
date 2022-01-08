import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pr2/chart/sensor_values_line_chart/sensor_value_format_helper.dart';
import 'package:pr2/models/current.dart';

import 'line_chart_helper.dart';
import 'sensor_line_chart_bar_data.dart';
import 'sensor_value_spot.dart';

class RealtimeValuesLineChart extends StatefulWidget {
  const RealtimeValuesLineChart({
    Key? key,
    required this.intervalSeconds,
    required this.pastMinuteValueToShow,
    required this.controller,
  }) : super(key: key);

  final int intervalSeconds;
  final int pastMinuteValueToShow;
  final RealtimeValuesLineChartController controller;

  @override
  _RealtimeValuesLineChartState createState() =>
      _RealtimeValuesLineChartState();
}

class _RealtimeValuesLineChartState extends State<RealtimeValuesLineChart> {
  final timePoints = <SensorValueSpot>[];
  final airHumidityPoints = <SensorValueSpot>[];
  final airTemperaturePoints = <SensorValueSpot>[];
  final soilTemperaturePoints = <SensorValueSpot>[];
  final soilMoisturePoints = <SensorValueSpot>[];
  final lightPoints = <SensorValueSpot>[];

  final random = Random();

  final SensorValueFormatHelper _formatHelper = SensorValueFormatHelper();
  late LineChartHelper _chartHelper;

  late int limitCount;

  @override
  void initState() {
    super.initState();
    _chartHelper = LineChartHelper(sensorValueFormatHelper: _formatHelper);
    limitCount = widget.pastMinuteValueToShow * 60 ~/ widget.intervalSeconds;
    widget.controller.addSensorValues = addSensorValues;
  }

  void addSensorValues(Current current) {
    while (airHumidityPoints.length > limitCount) {
      timePoints.removeAt(0);
      airHumidityPoints.removeAt(0);
      airTemperaturePoints.removeAt(0);
      soilTemperaturePoints.removeAt(0);
      soilMoisturePoints.removeAt(0);
      lightPoints.removeAt(0);
    }
    setState(() {
      double seconds = current.seconds;

      double airHumidity = current.airHumidity;
      double airTemp = current.airTemperature;
      double soilTemp = current.soilTemperature;
      double soilMoisture = current.soilMoisture;
      double light = current.light;

      bool refreshTemp = false;

      timePoints.add(SensorValueSpot.ofTime(seconds));

      airHumidityPoints
          .add(SensorValueSpot.ofAirHumidity(seconds, airHumidity));

      if (_formatHelper.updateTemperature(airTemp)) {
        refreshTemp = true;
      }
      airTemperaturePoints.add(SensorValueSpot.ofAirTemperature(
          seconds, airTemp, _formatHelper.maxTemp, _formatHelper.minTemp));

      if (_formatHelper.updateTemperature(soilTemp)) {
        refreshTemp = true;
      }
      soilTemperaturePoints.add(SensorValueSpot.ofSoilTemperature(
          seconds, soilTemp, _formatHelper.maxTemp, _formatHelper.minTemp));

      soilMoisturePoints
          .add(SensorValueSpot.ofSoilMoisture(seconds, soilMoisture));
      lightPoints.add(SensorValueSpot.ofLight(seconds, light));

      if (refreshTemp) {
        refreshTemperatureGraph();
      }
    });
  }

  void refreshTemperatureGraph() {
    for (int i = 0; i < airTemperaturePoints.length; i++) {
      SensorValueSpot temp = airTemperaturePoints[i];
      airTemperaturePoints[i] = SensorValueSpot.ofAirTemperature(
          temp.x, temp.value, _formatHelper.maxTemp, _formatHelper.minTemp);
    }
    for (int i = 0; i < soilTemperaturePoints.length; i++) {
      SensorValueSpot temp = soilTemperaturePoints[i];
      soilTemperaturePoints[i] = SensorValueSpot.ofSoilTemperature(
          temp.x, temp.value, _formatHelper.maxTemp, _formatHelper.minTemp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return airHumidityPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: 100,
                    minX: airHumidityPoints.last.x -
                        (widget.pastMinuteValueToShow * 60),
                    maxX: airHumidityPoints.last.x,
                    lineTouchData: _chartHelper.lineTouchData,
                    clipData: FlClipData.all(),
                    gridData: FlGridData(
                      show: false,
                      drawVerticalLine: false,
                    ),
                    lineBarsData: [
                      SensorLineChartBarData.withFade(
                        timePoints,
                        Colors.white,
                        showSpots: false,
                      ), // Add time title to tooltip.
                      SensorLineChartBarData.withFade(
                          airHumidityPoints, Colors.blueAccent),
                      SensorLineChartBarData.withFade(
                          airTemperaturePoints, Colors.redAccent),
                      SensorLineChartBarData.withFade(
                          soilTemperaturePoints, Colors.greenAccent),
                      SensorLineChartBarData.withFade(
                          soilMoisturePoints, Colors.brown),
                      SensorLineChartBarData.withFade(
                          lightPoints, Colors.orangeAccent),
                    ],
                    titlesData: _chartHelper.titlesData,
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}

class RealtimeValuesLineChartController {
  List<Current> toAdd = List.empty(growable: true);
  Function(Current current)? _addSensorValues;

  set addSensorValues(Function(Current current)? function) {
    _addSensorValues = function;
    if (_addSensorValues != null) {
      for (var element in toAdd) {
        _addSensorValues?.call(element);
      }
    }
  }

  void add(current) {
    if (_addSensorValues != null) {
      _addSensorValues?.call(current);
    } else {
      toAdd.add(current);
    }
  }
}
