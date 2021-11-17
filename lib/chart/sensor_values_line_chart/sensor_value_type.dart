enum SensorValueType {
  noData,
  time,
  airHumidity,
  airTemperature,
  soilTemperature,
  soilMoisture,
  light,
}

extension SensorValueTypeExtension on SensorValueType {
  static const names = {
    SensorValueType.noData: 'No Data',
    SensorValueType.airHumidity: 'Humidity',
    SensorValueType.airTemperature: 'Air Temp.',
    SensorValueType.soilTemperature: 'Soil Temp.',
    SensorValueType.soilMoisture: 'Soil Moisture',
    SensorValueType.light: 'Light',
  };

  String get name => names[this] ?? '';
}
