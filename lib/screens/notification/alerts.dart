import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/models/alert.dart';
import 'package:pr2/models/alerts_list_stream_publisher.dart';
import 'package:pr2/models/factor.dart';
import 'package:pr2/screens/notification/add_edit_alert.dart';

class Alerts extends StatefulWidget {
  const Alerts({Key? key}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late ScrollController scrollController;
  bool isScrolledToTop = true;

  Stream<List<Alert>>? alertsListStream =
      AlertsListStreamPublisher().getAlertsListStream();

  List<Alert> alerts = List.empty();

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
          backgroundColor: Colors.white,
          elevation: isScrolledToTop ? 0.0 : 4.0,
        ),
        body: StreamBuilder(
            stream: alertsListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                alerts = snapshot.data as List<Alert>;
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(
                              text: alerts.length.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' Alerts Set'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16.0,
                        );
                      },
                      padding: const EdgeInsets.only(bottom: 64.0),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        Alert alert = alerts[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditAlert(
                                          add: false,
                                          factor: alert.factor,
                                          onIncrease: alert.onIncrease,
                                          value: alert.value.toDouble(),
                                        )));
                          },
                          child: CustomCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: alert.factor.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    alert.factor.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${alert.value / alert.factor.divider} ${alert.factor.sign}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8.0),
                                  alert.onIncrease
                                      ? const Icon(
                                          Icons.arrow_drop_up,
                                          color: Color(0xFF00FF88),
                                        )
                                      : const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFFFF6161),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      controller: scrollController,
                    ),
                  ],
                ),
              );
            }));
  }
}
