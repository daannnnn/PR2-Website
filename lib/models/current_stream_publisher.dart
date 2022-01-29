import 'package:firebase_database/firebase_database.dart';
import 'current.dart';

import 'package:pr2/constants.dart';

class CurrentStreamPublisher {
  Stream<Current> getCurrentStream(DatabaseReference baseDatabaseRef) {
    final currentStream = baseDatabaseRef.child(CURRENT).onValue;
    final stream = currentStream.map((event) {
      return Current.fromRTDB(Map<String, dynamic>.from(event.snapshot.value));
    });
    return stream;
  }
}
