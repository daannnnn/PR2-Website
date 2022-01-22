import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/models/alert_notification.dart';
import 'package:pr2/models/alert_notifications_list_stream_publisher.dart';
import 'package:pr2/models/factor.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late ScrollController scrollController;
  bool isScrolledToTop = true;

  Stream<List<AlertNotification>>? alertNotificationsListStream =
      AlertNotificationsListStreamPublisher().getAlertNotificationsListStream();

  List<AlertNotification> alertNotifications = List.empty();

  final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    super.initState();

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
          title: Text('Notifications',
              style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: isScrolledToTop ? 0.0 : 4.0,
        ),
        body: StreamBuilder(
            stream: alertNotificationsListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                alertNotifications = snapshot.data as List<AlertNotification>;
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Divider(height: 1.0, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8.0),
                    ],
                  );
                },
                itemCount: alertNotifications.length,
                itemBuilder: (context, index) {
                  final notif = alertNotifications[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Container(
                        width: 24.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(2.0),
                          color: notif.factor.color,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Went ${notif.onIncrease ? 'above' : 'below'} ${(notif.value / notif.factor.divider).toString().replaceAll(regex, '')}${notif.factor.sign}'
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.overline,
                      ),
                      Text(
                        '${notif.factor.name} at ${(notif.alertValue / notif.factor.divider).toString().replaceAll(regex, '')}${notif.factor.sign}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMMd().add_jms().format(notif.date),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  );
                },
                controller: scrollController,
              );
            }));
  }
}
