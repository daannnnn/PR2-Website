import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

enum _Factor {
  airHumidity,
  airTemperature,
  soilTemperature,
  soilMoisture,
  light
}

extension _FactorExtension on _Factor {
  int get divider {
    switch (this) {
      case _Factor.airHumidity:
        return 100;
      case _Factor.airTemperature:
        return 10;
      case _Factor.soilTemperature:
        return 10;
      case _Factor.soilMoisture:
        return 100;
      case _Factor.light:
        return 100;
      default:
        return 1;
    }
  }

  String get sign {
    switch (this) {
      case _Factor.airHumidity:
        return '%';
      case _Factor.airTemperature:
        return '°C';
      case _Factor.soilTemperature:
        return '°C';
      case _Factor.soilMoisture:
        return '%';
      case _Factor.light:
        return '%';
      default:
        return '';
    }
  }

  String get name {
    switch (this) {
      case _Factor.airHumidity:
        return 'Air Humidity';
      case _Factor.airTemperature:
        return 'Air Temperature';
      case _Factor.soilTemperature:
        return 'Soil Temperature';
      case _Factor.soilMoisture:
        return 'Soil Moisture';
      case _Factor.light:
        return 'Light';
      default:
        return '';
    }
  }
}

final factorMap = {
  AIR_HUMIDITY: _Factor.airHumidity,
  AIR_TEMPERATURE: _Factor.airTemperature,
  SOIL_TEMPERATURE: _Factor.soilTemperature,
  SOIL_MOISTURE: _Factor.soilMoisture,
  LIGHT: _Factor.light,
};
final regex = RegExp(r"([.]*0)(?!.*\d)");

Future<void> showNotification(
  int notificationId,
  RemoteMessage message, {
  String channelId = '1234',
  String channelTitle = 'Channel',
}) async {
  _Factor? factor = factorMap[message.data["p"]];
  String title = '';
  title += factor?.name ?? '';
  title += message.data["r"].toLowerCase() == 'true' ? " above " : " below ";
  title += (int.parse(message.data["q"]) / (factor?.divider ?? 1))
      .toString()
      .replaceAll(regex, "");
  title += factor?.sign ?? '';

  String body = '';
  body += factor?.name ?? '';
  body += ' of ';
  body += (int.parse(message.data["u"]) / (factor?.divider ?? 1))
      .toString()
      .replaceAll(regex, "");
  body += factor?.sign ?? '';
  body += ' recorded at ';
  body += DateFormat.jms().format(DateTime.fromMillisecondsSinceEpoch(
      (int.parse(message.data['d'])) * 1000));
  body += '.';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    platformChannelSpecifics,
  );
}

int generateNewId() {
  String time = DateTime.now().millisecondsSinceEpoch.toString();
  String tmp = time.substring(time.length - 5);
  return int.tryParse(tmp) ?? 0;
}
