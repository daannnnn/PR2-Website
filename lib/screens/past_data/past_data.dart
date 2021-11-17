import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/models/past_data_future.dart';
import 'package:pr2/models/past_sensor_data.dart';
import 'package:pr2/screens/dashboard/sensor_data_row.dart';

class PastData extends StatefulWidget {
  const PastData({Key? key}) : super(key: key);

  @override
  State<PastData> createState() => _PastDataState();
}

class _PastDataState extends State<PastData> {
  late ScrollController scrollController;
  bool isScrolledToTop = true;

  final pastDataFuture = PastDataFuture().getPastDataFuture();

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
            List<PastSensorData> data = snapshot.data as List<PastSensorData>;
            return ListView.separated(
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
                      Text(DateFormat.MMMMd().add_jm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (data[index].hour) * 60 * 60 * 1000))),
                      const SizedBox(height: 8.0),
                      SensorDataRow(sensorValue: data[index]),
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
