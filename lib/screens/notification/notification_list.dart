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
                padding: const EdgeInsets.all(24.0),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemCount: alertNotifications.length,
                itemBuilder: (context, index) {
                  final notif = alertNotifications[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(DateFormat.yMMMd().add_jms().format(notif.date)),
                          Text(notif.factor.name +
                              (notif.onIncrease ? ' above ' : ' below ') +
                              (notif.value / notif.factor.divider).toString() +
                              notif.factor.sign +
                              ' with value of ' +
                              (notif.alertValue / notif.factor.divider)
                                  .toString() +
                              notif.factor.sign +
                              '.')
                        ],
                      ),
                    ),
                  );
                },
                controller: scrollController,
              );
            }));
  }
}
