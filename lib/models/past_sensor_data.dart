import 'package:pr2/constants.dart';
import 'package:pr2/models/sensor_value.dart';

class PastSensorData extends SensorValue {
  final int hour;

  PastSensorData({
    required this.hour,
    airHumidity,
    airTemperature,
    soilTemperature,
    soilMoisture,
    light,
  }) : super(
          airHumidity: airHumidity,
          airTemperature: airTemperature,
          soilTemperature: soilTemperature,
          soilMoisture: soilMoisture,
          light: light,
        );

  factory PastSensorData.fromRTDB(Map<String, dynamic> data) {
    return PastSensorData(
      hour: data[DATE] as int,
      airHumidity: (data[AIR_HUMIDITY] as int).toDouble() / 100,
      airTemperature: (data[AIR_TEMPERATURE] as int).toDouble() / 10,
      soilTemperature: (data[SOIL_TEMPERATURE] as int).toDouble() / 10,
      soilMoisture: (data[SOIL_MOISTURE] as int).toDouble() / 100,
      light: (data[LIGHT] as int).toDouble() / 100,
    );
  }
}
