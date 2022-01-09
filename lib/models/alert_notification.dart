import 'package:pr2/constants.dart';
import 'package:pr2/models/alert.dart';

class AlertNotification extends Alert {
  final DateTime date;
  final int alertValue;

  AlertNotification({
    required String id,
    required String factor,
    required int value,
    required bool onIncrease,
    required int date,
    required this.alertValue,
  })  : date = DateTime.fromMillisecondsSinceEpoch(date * 1000),
        super(id: id, factor: factor, value: value, onIncrease: onIncrease);

  factory AlertNotification.fromRTDB(String id, Map<String, dynamic> data) {
    return AlertNotification(
      id: id,
      factor: data[FACTOR],
      value: data[VALUE],
      onIncrease: data[ON_INCREASE],
      date: data[DATE],
      alertValue: data[ALERT_VALUE],
    );
  }
}
