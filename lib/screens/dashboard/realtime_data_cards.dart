import 'package:flutter/material.dart';
import 'package:pr2/chart/sensor_values_line_chart/sensor_values_line_chart.dart';
import 'package:pr2/models/current.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'data_card.dart';

class RealtimeDataCards extends StatelessWidget {
  const RealtimeDataCards(
      {Key? key, required this.current, required this.controller})
      : super(key: key);

  final Current current;
  final SensorValuesLineChartController controller;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridRow(
      rowSegments: 100,
      children: [
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
              "Air Humidity", current.strAirHumidity(), Colors.blueAccent),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
              "Air Temperature", current.strAirTemperature(), Colors.redAccent),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard("Soil Temperature", current.strSoilTemperature(),
              Colors.greenAccent),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
              "Soil Moisture", current.strSoilMoisture(), Colors.brown),
        ),
        ResponsiveGridCol(
          lg: 0,
          xs: 25,
          child: const SizedBox(),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard("Light", current.strLight(), Colors.orangeAccent),
        ),
        ResponsiveGridCol(
          lg: 0,
          xs: 25,
          child: const SizedBox(),
        ),
      ],
    );
  }
}
