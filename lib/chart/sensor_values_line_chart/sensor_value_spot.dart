import 'package:fl_chart/fl_chart.dart';

import 'sensor_value_type.dart';

class SensorValueSpot extends FlSpot {
  late final SensorValueType type;
  late final double value;

  SensorValueSpot(double x, double y, this.type, this.value) : super(x, y);

  SensorValueSpot.ofAirHumidity(double x, y)
      : this._ofPercentage(x, y, SensorValueType.airHumidity);

  SensorValueSpot.ofAirTemperature(double x, y, maxTemp, minTemp)
      : this._ofTemperature(
            x, y, maxTemp, minTemp, SensorValueType.airTemperature);

  SensorValueSpot.ofSoilTemperature(double x, y, maxTemp, minTemp)
      : this._ofTemperature(
            x, y, maxTemp, minTemp, SensorValueType.soilTemperature);

  SensorValueSpot.ofSoilMoisture(double x, y)
      : this._ofPercentage(x, y, SensorValueType.soilMoisture);

  SensorValueSpot.ofLight(double x, y)
      : this._ofPercentage(x, y, SensorValueType.light);

  SensorValueSpot.ofTime(double x) : super(x, 101) {
    value = 101; // To make the line and label positioned highest.
    type = SensorValueType.time;
  }

  SensorValueSpot.empty(x) : this._ofPercentage(x, 0, SensorValueType.noData);

  SensorValueSpot._ofPercentage(double x, y, this.type) : super(x, y) {
    value = y;
  }

  SensorValueSpot._ofTemperature(
      double x, double temperature, int maxTemp, int minTemp, this.type)
      : super(x, (temperature - minTemp) / (maxTemp - minTemp) * 100) {
    value = temperature;
  }

  bool isPercentage() {
    return type == SensorValueType.airHumidity ||
        type == SensorValueType.soilMoisture ||
        type == SensorValueType.light;
  }

  bool isTemperature() {
    return type == SensorValueType.airTemperature ||
        type == SensorValueType.soilTemperature;
  }

  bool isEmpty() {
    return type == SensorValueType.noData;
  }
}
