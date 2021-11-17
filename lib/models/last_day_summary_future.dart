import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/models/last_day_summary.dart';
import 'package:pr2/models/past_sensor_data.dart';

import '../constants.dart';

class LastDaySummaryFuture {
  final _database = FirebaseDatabase.instance.reference();

  Future<LastDaySummary?> getLastDaySummaryFuture() async {
    final endAt =
        ((DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor() *
                24) -
            1;
    final lastUpdate = await _database
        .child(VALUES)
        .orderByChild(DATE)
        .endAt(endAt)
        .limitToLast(1)
        .once();

    LastDaySummary? result;

    if (lastUpdate.exists) {
      final lastDate = Map<String, dynamic>.from(lastUpdate.value)
          .entries
          .first
          .value[DATE] as int;

      final initial = ((lastDate / 24).floor() * 24);
      final last = initial + 23;

      final data = await _database
          .child(VALUES)
          .orderByChild(DATE)
          .startAt(initial)
          .endAt(last)
          .once();

      final List<PastSensorData> resultList = [];
      Map<String, dynamic>.from(data.value).forEach((key, value) {
        resultList
            .add(PastSensorData.fromRTDB(Map<String, dynamic>.from(value)));
      });

      result = LastDaySummary.fromList(resultList);
    }

    return Future.value(result);
  }
}
