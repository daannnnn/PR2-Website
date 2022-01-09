import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'models/factor.dart';

final regex = RegExp(r"([.]*0)(?!.*\d)");

Future<void> showNotification(
  int notificationId,
  RemoteMessage message, {
  String channelId = '1234',
  String channelTitle = 'Channel',
}) async {
  Factor? factor = factorMap[message.data["p"]];
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
