import '../constants.dart';

enum Factor {
  airHumidity,
  airTemperature,
  soilTemperature,
  soilMoisture,
  light
}

extension FactorExtension on Factor {
  int get divider {
    switch (this) {
      case Factor.airHumidity:
        return 100;
      case Factor.airTemperature:
        return 10;
      case Factor.soilTemperature:
        return 10;
      case Factor.soilMoisture:
        return 100;
      case Factor.light:
        return 100;
      default:
        return 1;
    }
  }

  String get sign {
    switch (this) {
      case Factor.airHumidity:
        return '%';
      case Factor.airTemperature:
        return '°C';
      case Factor.soilTemperature:
        return '°C';
      case Factor.soilMoisture:
        return '%';
      case Factor.light:
        return '%';
      default:
        return '';
    }
  }

  String get name {
    switch (this) {
      case Factor.airHumidity:
        return 'Air Humidity';
      case Factor.airTemperature:
        return 'Air Temperature';
      case Factor.soilTemperature:
        return 'Soil Temperature';
      case Factor.soilMoisture:
        return 'Soil Moisture';
      case Factor.light:
        return 'Light';
      default:
        return '';
    }
  }

  String get key {
    switch (this) {
      case Factor.airHumidity:
        return AIR_HUMIDITY;
      case Factor.airTemperature:
        return AIR_TEMPERATURE;
      case Factor.soilTemperature:
        return SOIL_TEMPERATURE;
      case Factor.soilMoisture:
        return SOIL_MOISTURE;
      case Factor.light:
        return LIGHT;
      default:
        return '';
    }
  }
}

final factorMap = {
  AIR_HUMIDITY: Factor.airHumidity,
  AIR_TEMPERATURE: Factor.airTemperature,
  SOIL_TEMPERATURE: Factor.soilTemperature,
  SOIL_MOISTURE: Factor.soilMoisture,
  LIGHT: Factor.light,
};
