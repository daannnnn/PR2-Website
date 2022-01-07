class SensorValue {
  double airHumidity = 0;
  double airTemperature = 0;
  double soilTemperature = 0;
  double soilMoisture = 0;
  double light = 0;

  SensorValue({
    required this.airHumidity,
    required this.airTemperature,
    required this.soilTemperature,
    required this.soilMoisture,
    required this.light,
  });

  String strAirHumidity() => '$airHumidity%';
  String strAirTemperature() => '$airTemperature°C';
  String strSoilTemperature() => '$soilTemperature°C';
  String strSoilMoisture() => '$soilMoisture%';
  String strLight() => '$light%';
}
