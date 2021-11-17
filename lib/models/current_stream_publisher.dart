import 'package:firebase_database/firebase_database.dart';
import 'current.dart';

import 'package:pr2/constants.dart';

class CurrentStreamPublisher {
  final _database = FirebaseDatabase.instance.reference();

  Stream<Current> getCurrentStream() {
    final currentStream = _database.child(CURRENT).onValue;
    final stream = currentStream.map((event) {
      return Current.fromRTDB(Map<String, dynamic>.from(event.snapshot.value));
    });
    return stream;
  }
}
