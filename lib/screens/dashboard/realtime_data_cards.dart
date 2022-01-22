import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pr2/chart/sensor_values_line_chart/realtime_values_line_chart.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/models/current.dart';
import 'package:pr2/models/factor.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'data_card.dart';

class RealtimeDataCards extends StatelessWidget {
  const RealtimeDataCards({
    Key? key,
    required this.current,
    required this.controller,
    required this.goToNotifications,
    required this.goToEditAlerts,
  }) : super(key: key);

  final Current current;
  final RealtimeValuesLineChartController controller;

  final void Function() goToNotifications;
  final void Function() goToEditAlerts;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      rowSegments: 100,
      children: [
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
            Factor.airHumidity.name,
            current.strAirHumidity(),
            Factor.airHumidity.color,
          ),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
            Factor.airTemperature.name,
            current.strAirTemperature(),
            Factor.airTemperature.color,
          ),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
            Factor.soilTemperature.name,
            current.strSoilTemperature(),
            Factor.soilTemperature.color,
          ),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
            Factor.soilMoisture.name,
            current.strSoilMoisture(),
            Factor.soilMoisture.color,
          ),
        ),
        ResponsiveGridCol(
          lg: 20,
          xs: 50,
          child: DataCard(
            Factor.light.name,
            current.strLight(),
            Factor.light.color,
          ),
        ),
        if (Platform.isAndroid)
          ResponsiveGridCol(
            lg: 20,
            xs: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: goToNotifications,
                    child: CustomCard(
                      child: Row(
                        children: [
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.notifications_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: goToEditAlerts,
                    child: CustomCard(
                      child: Row(
                        children: [
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.notifications_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Edit Alerts',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
