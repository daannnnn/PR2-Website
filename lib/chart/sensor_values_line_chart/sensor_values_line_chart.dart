import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/models/current.dart';

import 'sensor_line_chart_bar_data.dart';
import 'sensor_value_spot.dart';
import 'sensor_value_type.dart';

class SensorValuesLineChart extends StatefulWidget {
  const SensorValuesLineChart({
    Key? key,
    required this.intervalSeconds,
    required this.pastMinuteValueToShow,
    required this.controller,
  }) : super(key: key);

  final int intervalSeconds;
  final int pastMinuteValueToShow;
  final SensorValuesLineChartController controller;

  @override
  _SensorValuesLineChartState createState() => _SensorValuesLineChartState();
}

class _SensorValuesLineChartState extends State<SensorValuesLineChart> {
  final timePoints = <SensorValueSpot>[];
  final airHumidityPoints = <SensorValueSpot>[];
  final airTemperaturePoints = <SensorValueSpot>[];
  final soilTemperaturePoints = <SensorValueSpot>[];
  final soilMoisturePoints = <SensorValueSpot>[];
  final lightPoints = <SensorValueSpot>[];

  final random = Random();

  int maxTemp = 40;
  int minTemp = 20;

  late int limitCount;

  @override
  void initState() {
    super.initState();
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

      if (airTemp > maxTemp) {
        refreshTemp = true;
        maxTemp = airTemp.ceil() + 5;
      }
      if (airTemp < minTemp) {
        refreshTemp = true;
        minTemp = airTemp.floor() - 5;
      }
      airTemperaturePoints.add(
          SensorValueSpot.ofAirTemperature(seconds, airTemp, maxTemp, minTemp));

      if (soilTemp > maxTemp) {
        refreshTemp = true;
        maxTemp = soilTemp.ceil() + 5;
        refreshTemperatureGraph();
      }
      if (soilTemp < minTemp) {
        refreshTemp = true;
        minTemp = soilTemp.floor() - 5;
      }
      soilTemperaturePoints.add(SensorValueSpot.ofSoilTemperature(
          seconds, soilTemp, maxTemp, minTemp));

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
          temp.x, temp.value, maxTemp, minTemp);
    }
    for (int i = 0; i < soilTemperaturePoints.length; i++) {
      SensorValueSpot temp = soilTemperaturePoints[i];
      soilTemperaturePoints[i] = SensorValueSpot.ofSoilTemperature(
          temp.x, temp.value, maxTemp, minTemp);
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
                    lineTouchData: lineTouchData,
                    clipData: FlClipData.all(),
                    gridData: FlGridData(
                      show: false,
                      drawVerticalLine: false,
                    ),
                    lineBarsData: [
                      SensorLineChartBarData(
                        timePoints,
                        Colors.white,
                        showSpots: false,
                      ), // Add time title to tooltip.
                      SensorLineChartBarData(
                          airHumidityPoints, Colors.blueAccent),
                      SensorLineChartBarData(
                          airTemperaturePoints, Colors.redAccent),
                      SensorLineChartBarData(
                          soilTemperaturePoints, Colors.greenAccent),
                      SensorLineChartBarData(soilMoisturePoints, Colors.brown),
                      SensorLineChartBarData(lightPoints, Colors.orangeAccent),
                    ],
                    titlesData: titlesData,
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  LineTouchData get lineTouchData => LineTouchData(
        getTouchedSpotIndicator: (bar, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(strokeWidth: 0),
              FlDotData(
                getDotPainter: (
                  FlSpot spot,
                  double xPercentage,
                  LineChartBarData bar,
                  int index,
                ) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: bar.colors[1],
                    strokeColor: Colors.transparent,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: touchTooltipData,
      );

  LineTouchTooltipData get touchTooltipData => LineTouchTooltipData(
      tooltipBgColor: Colors.black.withOpacity(0.5),
      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
        return touchedBarSpots.map((barSpot) {
          String text;
          if (barSpot.bar.spots[barSpot.spotIndex] is SensorValueSpot) {
            SensorValueSpot spot =
                barSpot.bar.spots[barSpot.spotIndex] as SensorValueSpot;
            if (spot.type != SensorValueType.noData &&
                spot.type != SensorValueType.time) {
              text =
                  '${spot.type.name}: ${spot.isPercentage() ? '${spot.y.toStringAsFixed(2)}%' : '${((spot.y / 100 * (maxTemp - minTemp)) + minTemp).toStringAsFixed(2)}°C'}';
            } else if (spot.type == SensorValueType.time) {
              text = DateFormat.jms().format(
                  DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000));
            } else {
              text = SensorValueType.noData.name;
            }
          } else {
            text = 'Error';
          }
          return LineTooltipItem(
            text,
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            textAlign: TextAlign.left,
          );
        }).toList();
      });

  FlTitlesData get titlesData => FlTitlesData(
      show: true,
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(showTitles: false),
      rightTitles: getSideTitles(
        getTitles: (double value) {
          return '${((value / 100 * (maxTemp - minTemp)) + minTemp).toStringAsFixed(0)}°C';
        },
      ),
      leftTitles: getSideTitles(
        getTitles: (double value) {
          return '${value.toInt()}%';
        },
        interval: 25.0,
      ));

  SideTitles getSideTitles({
    String Function(double value)? getTitles,
    double? interval,
    double? margin,
  }) {
    return SideTitles(
      showTitles: true,
      reservedSize: 40,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff72719b),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      getTitles: getTitles,
      interval: interval,
      margin: margin,
    );
  }
}

class SensorValuesLineChartController {
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
