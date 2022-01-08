import 'package:pr2/models/day_summary.dart';
import 'package:pr2/models/past_sensor_data.dart';

class DaySensorData extends DaySummary {
  final List<PastSensorData> hourlyData;

  DaySensorData({
    date,
    airHumidity,
    airTemperature,
    soilTemperature,
    soilMoisture,
    light,
  })  : hourlyData = [
          PastSensorData(
            hour: 0,
            airHumidity: airHumidity,
            airTemperature: airTemperature,
            soilTemperature: soilTemperature,
            soilMoisture: soilMoisture,
            light: light,
          )
        ],
        super(
          date: date,
          airHumidity: airHumidity,
          airTemperature: airTemperature,
          soilTemperature: soilTemperature,
          soilMoisture: soilMoisture,
          light: light,
        );

  DaySensorData.fromList({
    required this.hourlyData,
  }) : super.fromList(hourlyData);
}
