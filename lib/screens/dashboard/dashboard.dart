import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pr2/constants.dart';
import 'package:pr2/models/current.dart';
import 'package:pr2/models/current_stream_publisher.dart';
import 'package:pr2/screens/notification/alerts/alerts.dart';
import 'package:pr2/screens/notification/notification_list.dart';
import 'package:pr2/screens/past_data/past_data.dart';
import 'package:pr2/screens/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../notification.dart';
import 'past_data_summary.dart';
import 'realtime_data.dart';
import 'package:universal_html/html.dart' as html;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DatabaseReference baseDatabaseRef;

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  Stream<Current>? currentStream;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    baseDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child((user?.uid ?? '') + '/' + DATA);

    try {
      if (Platform.isAndroid && !kIsWeb) {
        SchedulerBinding.instance
            ?.addPostFrameCallback((_) => handleFCMToken());
      }
      // ignore: empty_catches
    } catch (e) {}

    currentStream = CurrentStreamPublisher().getCurrentStream(baseDatabaseRef);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isScrolledToTop) {
          setState(() {
            isScrolledToTop = true;
          });
        }
      } else {
        if (scrollController.offset > 0 && isScrolledToTop) {
          setState(() {
            isScrolledToTop = false;
          });
        }
      }
    });
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _createNotificationChannel('1234', 'Channel');

    try {
      if (Platform.isAndroid) {
        setFirebaseMessagingListener();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        actions: [
          if (kIsWeb)
            TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()],
                      ));
                    });
                final downloadURL = await FirebaseStorage.instance
                    .ref(apkFileName)
                    .getDownloadURL();
                Navigator.pop(context);
                html.AnchorElement anchorElement =
                    html.AnchorElement(href: downloadURL);
                anchorElement.download = downloadURL;
                anchorElement.click();
              },
              child: const Text('Download APK'),
            ),
          IconButton(
            onPressed: () async {
              setState(() {
                currentStream = null;
              });
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
              setState(() {
                currentStream =
                    CurrentStreamPublisher().getCurrentStream(baseDatabaseRef);
              });
            },
            icon: const Icon(Icons.settings_outlined),
            color: Colors.black87,
          ),
        ],
        title: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              RealtimeData(
                stream: currentStream,
                intervalSeconds: 2,
                pastMinuteValueToShow: kIsWeb ? 5 : 1,
                goToNotifications: () async {
                  setState(() {
                    currentStream = null;
                  });
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationList()));
                  setState(() {
                    currentStream = CurrentStreamPublisher()
                        .getCurrentStream(baseDatabaseRef);
                  });
                },
                goToEditAlerts: () async {
                  setState(() {
                    currentStream = null;
                  });
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Alerts()));
                  setState(() {
                    currentStream = CurrentStreamPublisher()
                        .getCurrentStream(baseDatabaseRef);
                  });
                },
              ),
              const SizedBox(height: 48.0),
              Divider(height: 1.0, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 48.0),
              PastDataSummary(
                goToPastData: () async {
                  setState(() {
                    currentStream = null;
                  });
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PastData()));
                  setState(() {
                    currentStream = CurrentStreamPublisher()
                        .getCurrentStream(baseDatabaseRef);
                  });
                },
                baseDatabaseRef: baseDatabaseRef,
              ),
            ],
          ),
        ),
        controller: scrollController,
      ),
    );
  }

  @override
  void dispose() {
    try {
      setState(() {
        currentStream = null;
      });
      // ignore: empty_catches
    } catch (e) {}
    super.dispose();
  }

  void setFirebaseMessagingListener() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(generateNewId(), message);
    });
  }

  Future<void> _createNotificationChannel(String id, String name) async {
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void handleFCMToken() async {
    final millis = await _getLastTokenRefreshTime();
    if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(millis))
            .inDays >=
        30) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text('Setting up notifications'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                ));
          });
      DatabaseReference ref = baseDatabaseRef.child(PREFERENCES).child(TOKENS);
      final key = await _getTokenKey() ?? ref.child(LIST).push().key;
      final token = await FirebaseMessaging.instance.getToken();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      await ref.update({
        '$LIST/$key': {
          DATE: ServerValue.timestamp,
          TOKEN: token,
          DEVICE_DETAIL: androidInfo.model
        },
        DATE: ServerValue.timestamp
      }).onError((error, stackTrace) => null);
      await _saveTokenKey(key);
      await _saveLastTokenRefreshTime();
      Navigator.pop(context);
    }
  }

  Future<void> _saveTokenKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('fcmTokenKey', key);
  }

  Future<String?> _getTokenKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('fcmTokenKey');
  }

  Future<void> _saveLastTokenRefreshTime() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(
        'lastTokenRefreshTime', DateTime.now().millisecondsSinceEpoch);
  }

  Future<int> _getLastTokenRefreshTime() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('lastTokenRefreshTime') ?? 0;
  }
}
