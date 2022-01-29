import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/constants.dart';
import 'package:rxdart/rxdart.dart';

import 'alert.dart';

class AlertsListStreamPublisher {
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<dynamic>> getAlertsListStream() {
    final alertsListStream =
        _database.child(PREFERENCES).child(ALERTS).child(LIST).onValue;
    final stream = alertsListStream.map((event) {
      if (event.snapshot.value == null) {
        return List<Alert>.empty(growable: true);
      }
      final list = List<Alert>.empty(growable: true);
      final map = Map<String, dynamic>.from(event.snapshot.value);
      map.forEach((key, value) {
        Alert alert = Alert.fromRTDB(key, Map<String, dynamic>.from(value));
        list.add(alert);
      });
      return list.reversed.toList();
    });

    final deviceAlertsListStream =
        _database.child(DEVICE_PREFERENCES).child(ALERTS).child(LIST).onValue;
    final deviceStream = deviceAlertsListStream.map((event) {
      if (event.snapshot.value == null) {
        return List<Alert>.empty(growable: true);
      }
      final list = List<Alert>.empty(growable: true);
      final map = Map<String, dynamic>.from(event.snapshot.value);
      map.forEach((key, value) {
        Alert alert = Alert.fromRTDB(key, Map<String, dynamic>.from(value));
        list.add(alert);
      });
      return list.reversed.toList();
    });
    final dateStream = _database
        .reference()
        .child(UPDATE_INFO)
        .child(DATE)
        .onValue
        .map((event) => event.snapshot);
    return CombineLatestStream.list([
      stream,
      deviceStream,
      dateStream,
    ]);
  }
}
