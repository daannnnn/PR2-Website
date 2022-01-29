import 'package:equatable/equatable.dart';
import 'package:pr2/constants.dart';

import 'factor.dart';

class Alert extends Equatable {
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

  @override
  List<Object?> get props => [id, factor, value, onIncrease];
}

class AlertWithState extends Alert {
  final AlertState state;

  AlertWithState({
    required this.state,
    required id,
    required factor,
    required value,
    required onIncrease,
  }) : super(
          id: id,
          factor: factor,
          value: value,
          onIncrease: onIncrease,
        );

  AlertWithState.fromAlert({
    required this.state,
    required Alert alert,
  }) : super(
          id: alert.id,
          factor: alert.factor.key,
          value: alert.value,
          onIncrease: alert.onIncrease,
        );
}

enum AlertState {
  ok,
  pendingSet,
  pendingDelete,
}
