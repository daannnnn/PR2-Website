import 'package:firebase_database/firebase_database.dart';
import 'package:pr2/models/alert_notification.dart';

import '../constants.dart';

class AlertNotificationsListStreamPublisher {
  Stream<List<AlertNotification>> getAlertNotificationsListStream(
      DatabaseReference baseDatabaseRef) {
    final alertNotificationsListStream =
        baseDatabaseRef.child(ALERT_LIST).onValue;
    final stream = alertNotificationsListStream.map((event) {
      final list = List<AlertNotification>.empty(growable: true);
      final map = Map<String, dynamic>.from(event.snapshot.value);
      map.forEach((key, value) {
        AlertNotification alert =
            AlertNotification.fromRTDB(key, Map<String, dynamic>.from(value));
        list.add(alert);
      });
      return list.reversed.toList();
    });
    return stream;
  }
}
