class SensorValue {
  final double airHumidity;
  final double airTemperature;
  final double soilTemperature;
  final double soilMoisture;
  final double light;

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
