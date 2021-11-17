import 'package:pr2/constants.dart';
import 'package:pr2/models/sensor_value.dart';

class Current extends SensorValue {
  final double seconds;

  Current({
    required this.seconds,
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

  factory Current.fromRTDB(Map<String, dynamic> data) {
    return Current(
      seconds: ((data[TOTAL][DATE] as int) - (8 * 60 * 60)).toDouble(),
      airHumidity: (data[AIR_HUMIDITY] as int).toDouble() / 100,
      airTemperature: (data[AIR_TEMPERATURE] as int).toDouble() / 10,
      soilTemperature: (data[SOIL_TEMPERATURE] as int).toDouble() / 10,
      soilMoisture: (data[SOIL_MOISTURE] as int).toDouble() / 100,
      light: (data[LIGHT] as int).toDouble() / 100,
    );
  }

  factory Current.empty() {
    return Current(
      seconds: 0.0,
      airHumidity: 0.0,
      airTemperature: 0.0,
      soilTemperature: 0.0,
      soilMoisture: 0.0,
      light: 0.0,
    );
  }
}
