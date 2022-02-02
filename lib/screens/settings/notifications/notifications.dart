import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pr2/models/token.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'notifications_pending_update_card.dart';
import 'notifications_updated_card.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key) {
    try {
      if (Platform.isAndroid) {
        android = true;
      } else {
        android = false;
      }
      // ignore: empty_catches
    } catch (e) {
      android = false;
    }
  }

  late final bool android;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late DatabaseReference baseDatabaseRef;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  int updateTime = 0;
  int deviceLastUpdateTime = -1;

  bool sendNotifications = false;
  bool deviceSendNotifications = false;

  List<Token> tokens = List.empty(growable: true);
  List<Token> deviceTokens = List.empty(growable: true);

  late String? tokenId;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    baseDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child((user?.uid ?? '') + '/' + DATA);

    _getTokenKey().then((value) {
      setState(() {
        tokenId = value;
      });
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
        ),
        title:
            Text('Notifications', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: StreamBuilder(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final list = snapshot.data as List<DataSnapshot>;

            final tokens = Map<String, dynamic>.from(list[0].value);
            final deviceTokens = list[1].value != null
                ? Map<String, dynamic>.from(list[1].value)
                : null;

            updateTime = tokens[DATE];
            final millis = int.tryParse(list[2].value.toString());
            if (millis != null) {
              deviceLastUpdateTime = millis;
            }

            this.tokens.clear();
            this.deviceTokens.clear();
            if (tokens[LIST] != null) {
              Map<String, dynamic>.from(tokens[LIST]).forEach((key, value) {
                this.tokens.add(Token(
                    id: key,
                    date: DateTime.fromMillisecondsSinceEpoch(value[DATE]),
                    token: value[TOKEN],
                    deviceDetail: value[DEVICE_DETAIL]));
              });
            }

            Token? mToken;
            if (deviceTokens != null) {
              Map<String, dynamic>.from(deviceTokens[LIST])
                  .forEach((key, value) {
                final t = Token(
                    id: key,
                    date: DateTime.fromMillisecondsSinceEpoch(value[DATE]),
                    token: value[TOKEN],
                    deviceDetail: value[DEVICE_DETAIL]);
                if (key == tokenId) {
                  mToken = t;
                } else {
                  this.deviceTokens.add(t);
                }
              });
            }
            if (mToken != null) this.deviceTokens.insert(0, mToken!);

            sendNotifications =
                this.tokens.indexWhere((element) => element.id == tokenId) !=
                    -1;

            deviceSendNotifications = this
                    .deviceTokens
                    .indexWhere((element) => element.id == tokenId) !=
                -1;
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.android)
                    Column(
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linearToEaseOut,
                          child: (updateTime > deviceLastUpdateTime) ||
                                  (sendNotifications != deviceSendNotifications)
                              ? NotificationsPendingUpdateCard(
                                  deviceLastUpdateTime:
                                      DateTime.fromMillisecondsSinceEpoch(
                                          deviceLastUpdateTime),
                                  currentSendNotifications:
                                      deviceSendNotifications,
                                  pendingSendNotifications: sendNotifications,
                                )
                              : NotificationsUpdatedCard(
                                  sendNotifications: deviceSendNotifications,
                                ),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            Text(
                              'Send notifications to this device',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Spacer(),
                            Switch(
                                value: sendNotifications,
                                onChanged: (b) async {
                                  if (tokenId == null) return;
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16.0),
                                            Text('Saving'),
                                          ],
                                        ));
                                      });
                                  final ref = baseDatabaseRef
                                      .child(PREFERENCES)
                                      .child(TOKENS)
                                      .child(LIST)
                                      .child(tokenId!);

                                  if (sendNotifications) {
                                    ref
                                        .remove()
                                        .then((value) => Navigator.pop(context))
                                        .onError((error, stackTrace) => null);
                                  } else {
                                    final token = await FirebaseMessaging
                                        .instance
                                        .getToken();
                                    final DeviceInfoPlugin deviceInfo =
                                        DeviceInfoPlugin();
                                    final AndroidDeviceInfo androidInfo =
                                        await deviceInfo.androidInfo;
                                    ref
                                        .set({
                                          DATE: ServerValue.timestamp,
                                          TOKEN: token,
                                          DEVICE_DETAIL: androidInfo.model
                                        })
                                        .then((value) => Navigator.pop(context))
                                        .onError((error, stackTrace) => null);
                                  }
                                })
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Divider(
                            height: 1.0, color: Colors.grey.withOpacity(0.5)),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  Text(
                    'Devices Receiving Notifications',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  if (deviceTokens.isNotEmpty)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Divider(
                            height: 1.0, color: Colors.grey.withOpacity(0.5));
                      },
                      padding: const EdgeInsets.only(left: 16.0),
                      itemCount: deviceTokens.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (deviceTokens[index].id == tokenId)
                                Text(
                                  'This device'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              Text(
                                deviceTokens[index].deviceDetail ?? 'NA',
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          ),
                        );
                      },
                      controller: scrollController,
                    )
                  else
                    const Text('No devices yet'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stream<List<DataSnapshot>> getData() {
    Stream<DataSnapshot> stream1 = baseDatabaseRef
        .child(PREFERENCES)
        .child(TOKENS)
        .onValue
        .map((event) => event.snapshot);
    Stream<DataSnapshot> stream2 = baseDatabaseRef
        .child(DEVICE_PREFERENCES)
        .child(TOKENS)
        .onValue
        .map((event) => event.snapshot);
    Stream<DataSnapshot> stream3 = baseDatabaseRef
        .child(UPDATE_INFO)
        .child(DATE)
        .onValue
        .map((event) => event.snapshot);
    return CombineLatestStream.list([
      stream1,
      stream2,
      stream3,
    ]);
  }

  Future<String?> _getTokenKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('fcmTokenKey');
  }
}
