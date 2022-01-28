import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/constants.dart';

import 'alert.dart';

class AlertsListStreamPublisher {
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<Alert>> getAlertsListStream() {
    final alertsListStream =
        _database.child(PREFERENCES).child(ALERTS).child(LIST).onValue;
    final stream = alertsListStream.map((event) {
      final list = List<Alert>.empty(growable: true);
      final map = Map<String, dynamic>.from(event.snapshot.value);
      map.forEach((key, value) {
        Alert alert = Alert.fromRTDB(key, Map<String, dynamic>.from(value));
        list.add(alert);
      });
      return list.reversed.toList();
    });
    return stream;
  }
}
