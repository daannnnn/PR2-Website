import 'package:flutter/material.dart';
import 'package:pr2/models/sensor_value.dart';

import 'sensor_data_row_item.dart';

class SensorDataRow extends StatelessWidget {
  const SensorDataRow({Key? key, required this.sensorValue}) : super(key: key);

  final SensorValue sensorValue;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(children: [
        Expanded(
          child:
              SensorDataRowItem(sensorValue.strAirHumidity(), 'Air Humidity'),
          flex: 1,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child:
              SensorDataRowItem(sensorValue.strAirTemperature(), 'Air Temp.'),
          flex: 1,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child:
              SensorDataRowItem(sensorValue.strSoilTemperature(), 'Soil Temp.'),
          flex: 1,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child:
              SensorDataRowItem(sensorValue.strSoilMoisture(), 'Soil Moisture'),
          flex: 1,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: SensorDataRowItem(sensorValue.strLight(), 'Light'),
          flex: 1,
        )
      ]),
    );
  }
}
