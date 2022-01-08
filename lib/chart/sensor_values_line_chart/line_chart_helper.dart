import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/chart/sensor_values_line_chart/sensor_value_format_helper.dart';

import 'sensor_value_spot.dart';
import 'sensor_value_type.dart';

class LineChartHelper {
  final SensorValueFormatHelper _formatHelper;

  LineChartHelper({required sensorValueFormatHelper})
      : _formatHelper = sensorValueFormatHelper;

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
                    color: bar.colors.last,
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
                  '${spot.type.name}: ${spot.isPercentage() ? '${spot.y.toStringAsFixed(2)}%' : '${((spot.y / 100 * (_formatHelper.maxTemp - _formatHelper.minTemp)) + _formatHelper.minTemp).toStringAsFixed(2)}°C'}';
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
          return '${((value / 100 * (_formatHelper.maxTemp - _formatHelper.minTemp)) + _formatHelper.minTemp).toStringAsFixed(0)}°C';
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
