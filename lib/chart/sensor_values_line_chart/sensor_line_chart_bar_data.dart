import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'sensor_value_spot.dart';

class SensorLineChartBarData extends LineChartBarData {
  SensorLineChartBarData(List<SensorValueSpot> spots, Color color,
      {bool? showSpots})
      : super(
          spots: spots,
          dotData: FlDotData(
              show: showSpots ?? true,
              getDotPainter: (
                FlSpot spot,
                double xPercentage,
                LineChartBarData bar,
                int index,
              ) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: bar.colors[1].withOpacity(0.5),
                  strokeColor: Colors.transparent,
                );
              }),
          colors: [color.withOpacity(0), color.withOpacity(0.6)],
          colorStops: [0.0, 0.3],
          barWidth: 4,
          isCurved: false,
        );
}
