import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pr2/chart/sensor_values_line_chart/realtime_values_line_chart.dart';
import 'package:pr2/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'models/user_state.dart';
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
          return StreamProvider<UserState>.value(
            value: AuthService().user,
            initialData: UserState(user: null, loading: true),
            child: MaterialApp(
              title: 'TECHFRO',
              theme: ThemeData(
                primarySwatch: Colors.green,
                fontFamily: 'SourceSansPro',
                textTheme: const TextTheme(
                  headline6: TextStyle(fontWeight: FontWeight.w600),
                  button: TextStyle(fontWeight: FontWeight.w600),
                  subtitle2: TextStyle(fontWeight: FontWeight.w600),
                ),
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
