import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/models/day_summary.dart';
import 'package:pr2/models/past_sensor_data.dart';

import '../constants.dart';

class LastDaySummaryFuture {
  Future<DaySummary?> getLastDaySummaryFuture(
      DatabaseReference baseDatabaseReference) async {
    final endAt =
        ((DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor() *
                24) -
            1;
    final lastUpdate = await baseDatabaseReference
        .child(VALUES)
        .orderByChild(DATE)
        .endAt(endAt)
        .limitToLast(1)
        .once();

    DaySummary? result;

    if (lastUpdate.exists) {
      final lastDate = Map<String, dynamic>.from(lastUpdate.value)
          .entries
          .first
          .value[DATE] as int;

      final initial = ((lastDate / 24).floor() * 24);
      final last = initial + 23;

      final data = await baseDatabaseReference
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

      result = DaySummary.fromList(resultList);
    }

    return Future.value(result);
  }
}
