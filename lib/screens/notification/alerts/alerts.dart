import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pr2/constants.dart';
import 'package:pr2/models/alert.dart';
import 'package:pr2/models/alerts_list_stream_publisher.dart';
import 'package:pr2/screens/notification/add_edit_alert.dart';
import 'package:pr2/screens/notification/alerts/alert_card.dart';
import 'package:pr2/screens/notification/alerts/alerts_pending_update_card.dart';
import 'package:pr2/screens/notification/alerts/alerts_updated_card.dart';

class Alerts extends StatefulWidget {
  const Alerts({Key? key}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late DatabaseReference baseDatabaseRef;

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  late Stream<dynamic>? alertsListStream;

  List<AlertWithState> combinedAlerts = List.empty();
  List<AlertWithState> alertsPendingSet = List.empty();
  List<AlertWithState> alertsPendingDelete = List.empty();
  List<Alert> alertsOk = List.empty();

  int activeAlertCount = 0;
  DateTime deviceLastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    baseDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child((user?.uid ?? '') + '/' + DATA);

    alertsListStream =
        AlertsListStreamPublisher().getAlertsListStream(baseDatabaseRef);

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
        backgroundColor: const Color(0xFFF8F9FB),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEditAlert(add: true)));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left),
            color: Colors.black,
          ),
          title: Text('Alerts', style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
          backgroundColor: const Color(0xFFF8F9FB),
          elevation: isScrolledToTop ? 0.0 : 4.0,
        ),
        body: StreamBuilder(
            stream: alertsListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data as List<dynamic>;
                alertsPendingSet = (list[0] as List<Alert>)
                    .where((element) => !list[1].contains(element))
                    .map((e) => AlertWithState.fromAlert(
                        state: AlertState.pendingSet, alert: e))
                    .toList();
                alertsPendingDelete = (list[1] as List<Alert>)
                    .where((element) => !list[0].contains(element))
                    .map((e) => AlertWithState.fromAlert(
                        state: AlertState.pendingDelete, alert: e))
                    .toList();
                alertsOk = List.from(list[0] as List<Alert>);
                alertsOk.removeWhere((item) => !list[1].contains(item));

                combinedAlerts = [
                  alertsPendingSet,
                  alertsPendingDelete,
                  alertsOk
                      .map((e) => AlertWithState.fromAlert(
                          state: AlertState.ok, alert: e))
                      .toList(),
                ].expand((x) => x).toList();
                combinedAlerts.sort((a, b) => b.id.compareTo(a.id));

                activeAlertCount = alertsOk.length + alertsPendingDelete.length;

                final millis =
                    int.tryParse((list[2] as DataSnapshot).value.toString());
                if (millis != null) {
                  deviceLastUpdateTime =
                      DateTime.fromMillisecondsSinceEpoch(millis);
                }
              } else {
                combinedAlerts = List.empty();
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (alertsPendingDelete.isNotEmpty ||
                            alertsPendingSet.isNotEmpty)
                        ? AlertsPendingUpdateCard(
                            deviceLastUpdateTime: deviceLastUpdateTime,
                            pendingSetAlertCount: alertsPendingSet.length,
                            pendingDeleteAlertCount: alertsPendingDelete.length,
                          )
                        : const AlertsUpdatedCard(),
                    const SizedBox(height: 24.0),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(
                              text: activeAlertCount.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  ' ${activeAlertCount == 1 ? 'alert' : 'alerts'} currently active'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16.0,
                        );
                      },
                      padding: const EdgeInsets.only(bottom: 64.0),
                      itemCount: combinedAlerts.length,
                      itemBuilder: (context, index) {
                        AlertWithState alert = combinedAlerts[index];
                        return AlertCard(
                            alert: alert, baseDatabaseRef: baseDatabaseRef);
                      },
                    ),
                  ],
                ),
                controller: scrollController,
              );
            }));
  }
}
