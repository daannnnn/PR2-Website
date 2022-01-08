class SensorValueFormatHelper {
  int maxTemp;
  int minTemp;
  SensorValueFormatHelper({this.maxTemp = 40, this.minTemp = 20});

  bool updateTemperature(double temperature) {
    bool updated = false;
    if (temperature > maxTemp) {
      updated = true;
      maxTemp = temperature.ceil() + 5;
    }
    if (temperature < minTemp) {
      updated = true;
      minTemp = temperature.floor() - 5;
    }
    return updated;
  }
}
