import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/models/past_sensor_data.dart';

import '../constants.dart';

class PastDataFuture {
  final _database = FirebaseDatabase.instance.reference();

  Future<List<PastSensorData>> getPastDataFuture() async {
    final pastData = await _database.child(VALUES).orderByChild(DATE).once();

    List<PastSensorData> result = List.empty(growable: true);

    if (pastData.exists) {
      Map<String, dynamic>.from(pastData.value).forEach((key, value) {
        result.add(PastSensorData.fromRTDB(Map<String, dynamic>.from(value)));
      });
    }

    return Future.value(List.from(result.reversed));
  }
}
