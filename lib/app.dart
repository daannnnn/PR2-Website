import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pr2/chart/sensor_values_line_chart/realtime_values_line_chart.dart';
import 'package:pr2/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  final RealtimeValuesLineChartController controller =
      RealtimeValuesLineChartController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong!');
        } else if (snapshot.hasData) {
          return StreamProvider<User?>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
              title: 'PR2',
              theme: ThemeData(
                primarySwatch: Colors.green,
                fontFamily: 'OpenSans',
              ),
              home: const Wrapper(),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
