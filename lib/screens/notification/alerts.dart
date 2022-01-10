import 'package:flutter/material.dart';
import 'package:pr2/models/alert.dart';
import 'package:pr2/models/alerts_list_stream_publisher.dart';
import 'package:pr2/models/factor.dart';
import 'package:pr2/screens/notification/add_alert.dart';
import 'package:pr2/screens/notification/alert_details.dart';

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
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddAlert()));
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
              return ListView.separated(
                padding: const EdgeInsets.all(24.0),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(alerts[index].factor.name),
                          Text('When value goes ' +
                              (alerts[index].onIncrease ? 'above ' : 'below ') +
                              (alerts[index].value /
                                      alerts[index].factor.divider)
                                  .toString() +
                              alerts[index].factor.sign)
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
