import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pr2/chart/sensor_values_line_chart/realtime_values_line_chart.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/models/current.dart';
import 'package:pr2/models/factor.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'data_card.dart';

class RealtimeDataCards extends StatelessWidget {
  RealtimeDataCards({
    Key? key,
    required this.current,
    required this.controller,
    required this.goToNotifications,
    required this.goToEditAlerts,
  }) : super(key: key) {
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

  final Current current;
  final RealtimeValuesLineChartController controller;

  final void Function() goToNotifications;
  final void Function() goToEditAlerts;

  late final bool android;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = [
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomCard(
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
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: goToNotifications,
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 8.0,
        width: 8.0,
      ),
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomCard(
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Edit Alerts',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: goToEditAlerts,
              ),
            ),
          )
        ],
      ),
    ];
    return Column(
      children: [
        ResponsiveGridRow(
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
            if (android)
              ResponsiveGridCol(
                lg: 20,
                xs: 50,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(children: actionButtons)),
              ),
          ],
        ),
        if (!android)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Row(children: actionButtons),
          )
      ],
    );
  }
}
