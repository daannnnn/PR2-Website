import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/models/day_sensor_data.dart';
import 'package:pr2/models/past_sensor_data.dart';

import '../constants.dart';

class PastDataFuture {
  final _database = FirebaseDatabase.instance.reference();

  Future<List<DaySensorData>> getPastDataFuture() async {
    final pastData = await _database.child(VALUES).orderByChild(DATE).once();

    List<DaySensorData> result = List.empty(growable: true);

    List<PastSensorData> pastSensorData = List.empty(growable: true);
    if (pastData.exists) {
      var map = Map<String, dynamic>.from(pastData.value);
      var hour = PastSensorData.fromRTDB(
              Map<String, dynamic>.from(map[map.keys.first]))
          .hour;
      map.forEach((key, value) {
        final data = PastSensorData.fromRTDB(Map<String, dynamic>.from(value));

        if (isSameDay(hour, data.hour)) {
          pastSensorData.add(data);
        } else {
          result.add(
              DaySensorData.fromList(hourlyData: List.from(pastSensorData)));
          pastSensorData.clear();
          pastSensorData.add(data);
          hour = data.hour;
        }
      });
    }

    if (pastSensorData.isNotEmpty) {
      result.add(DaySensorData.fromList(hourlyData: pastSensorData));
    }

    return Future.value(List.from(result.reversed));
  }
}

bool isSameDay(int hour1, int hour2) {
  hour1 += DateTime.now().timeZoneOffset.inHours;
  hour2 += DateTime.now().timeZoneOffset.inHours;
  final hourStart = (hour1 / 24).floor() * 24;
  return hour2 >= hourStart && hour2 < hourStart + 24;
}
