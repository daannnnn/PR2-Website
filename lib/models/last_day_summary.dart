import 'package:pr2/models/past_sensor_data.dart';
import 'package:pr2/models/sensor_value.dart';

class LastDaySummary extends SensorValue {
  final DateTime date;

  LastDaySummary({
    required this.date,
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

  factory LastDaySummary.fromList(List<PastSensorData> pastData) {
    var totalAirHumidity = 0.0;
    var totalAirTemperature = 0.0;
    var totalSoilTemperature = 0.0;
    var totalSoilMoisture = 0.0;
    var totalLight = 0.0;
    var count = 0;

    for (var element in pastData) {
      totalAirHumidity += element.airHumidity;
      totalAirTemperature += element.airTemperature;
      totalSoilTemperature += element.soilTemperature;
      totalSoilMoisture += element.soilMoisture;
      totalLight += element.light;
      count++;
    }

    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(pastData[0].hour * 60 * 60 * 1000);
    double avgAirHumidity =
        double.parse((totalAirHumidity / count).toStringAsFixed(2));
    double avgAirTemperature =
        double.parse((totalAirTemperature / count).toStringAsFixed(2));
    double avgSoilTemperature =
        double.parse((totalSoilTemperature / count).toStringAsFixed(2));
    double avgSoilMoisture =
        double.parse((totalSoilMoisture / count).toStringAsFixed(2));
    double avgLight = double.parse((totalLight / count).toStringAsFixed(2));

    return LastDaySummary(
      date: date,
      airHumidity: avgAirHumidity,
      airTemperature: avgAirTemperature,
      soilTemperature: avgSoilTemperature,
      soilMoisture: avgSoilMoisture,
      light: avgLight,
    );
  }
}
