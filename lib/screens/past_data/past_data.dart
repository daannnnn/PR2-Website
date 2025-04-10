import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/chart/sensor_values_line_chart/day_summary_line_chart.dart';
import 'package:pr2/models/day_sensor_data.dart';
import 'package:pr2/models/past_data_future.dart';
import 'package:pr2/screens/dashboard/sensor_data_row.dart';

import '../../constants.dart';

class PastData extends StatefulWidget {
  const PastData({Key? key}) : super(key: key);

  @override
  State<PastData> createState() => _PastDataState();
}

class _PastDataState extends State<PastData> {
  late DatabaseReference baseDatabaseRef;

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  late Future<List<DaySensorData>> pastDataFuture;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    baseDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child((user?.uid ?? '') + '/' + DATA);

    pastDataFuture = PastDataFuture().getPastDataFuture(baseDatabaseRef);

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
        title: Text('Past Data', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: FutureBuilder(
        future: pastDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DaySensorData> data = snapshot.data as List<DaySensorData>;
            return ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8.0,
                );
              },
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(DateFormat.yMMMMd().format(data[index].date)),
                      const SizedBox(height: 8.0),
                      SensorDataRow(sensorValue: data[index]),
                      DaySummaryLineChart(hourlyData: data[index].hourlyData),
                    ],
                  ),
                ));
              },
            );
          } else {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
