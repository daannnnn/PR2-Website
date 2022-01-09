import 'package:pr2/constants.dart';
import 'package:pr2/notification.dart';

import 'factor.dart';

class Alert {
  final String id;
  final Factor factor;
  final int value;
  final bool onIncrease;

  Alert(
      {required this.id,
      required String factor,
      required this.value,
      required this.onIncrease})
      : factor = factorMap[factor] ?? Factor.airHumidity;

  factory Alert.fromRTDB(String id, Map<String, dynamic> data) {
    return Alert(
      id: id,
      factor: data[FACTOR],
      value: data[VALUE],
      onIncrease: data[ON_INCREASE],
    );
  }
}
