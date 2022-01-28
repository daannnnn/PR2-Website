import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pr2/screens/settings/preferences/preferences_updated_card.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants.dart';
import 'preferences_pending_update_card.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  final _database = FirebaseDatabase.instance;

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  final updateIntervalValueController = TextEditingController();
  String? _updateIntervalError;

  int updateTime = 0;
  int deviceLastUpdateTime = -1;

  double updateInterval = -1;
  double deviceUpdateInterval = -1;

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
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                if ((double.tryParse(updateIntervalValueController.text) ?? 0) <
                    2) {
                  _updateIntervalError = 'Value can\'t be less than 2 seconds';
                } else if ((double.tryParse(
                            updateIntervalValueController.text) ??
                        0) ==
                    updateInterval) {
                  _updateIntervalError =
                      'Value can\'t be the same as the current value';
                } else {
                  _updateIntervalError = null;
                }
              });

              if (_updateIntervalError != null) {
                return;
              }

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Saving'),
                        CircularProgressIndicator()
                      ],
                    ));
                  });
              final ref =
                  _database.reference().child(PREFERENCES).child(USER_PREF);

              int count = 0;
              await ref
                  .update({
                    DATE: ServerValue.timestamp,
                    UPDATE_INTERVAL:
                        (double.tryParse(updateIntervalValueController.text) ??
                                0) *
                            1000
                  })
                  .then((value) => Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      }))
                  .onError((error, stackTrace) => null);
            },
            icon: const Icon(Icons.check),
            color: Colors.black,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
        ),
        title:
            Text('Preferences', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final list = snapshot.data as List<DataSnapshot>;

            final userPref = Map<String, dynamic>.from(list[0].value);
            final deviceUserPref = Map<String, dynamic>.from(list[1].value);
            final infoUserPref = Map<String, dynamic>.from(list[2].value);

            updateTime = userPref[DATE];
            deviceLastUpdateTime = infoUserPref[DATE];

            updateInterval =
                (double.tryParse(userPref[UPDATE_INTERVAL].toString()) ?? -1) /
                    1000;
            deviceUpdateInterval =
                (double.tryParse(deviceUserPref[UPDATE_INTERVAL].toString()) ??
                        -1) /
                    1000;
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                    child: (updateTime < deviceLastUpdateTime) ||
                            (updateInterval == deviceUpdateInterval)
                        ? PreferencesUpdatedCard(
                            updateInterval: deviceUpdateInterval)
                        : PreferencesPendingUpdateCard(
                            deviceLastUpdateTime:
                                DateTime.fromMillisecondsSinceEpoch(
                                    deviceLastUpdateTime),
                            currentUpdateInterval: deviceUpdateInterval,
                            pendingUpdateInterval: updateInterval,
                          ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Update Interval'.toUpperCase(),
                    style: Theme.of(context).textTheme.overline,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Update Interval',
                      suffixText: 'seconds',
                      helperText: 'Minimum of 2 seconds',
                      errorText: _updateIntervalError,
                    ),
                    keyboardType: TextInputType.number,
                    controller: updateIntervalValueController,
                  )
                ],
              ),
            ),
          );
        },
        stream: getDateData(),
      ),
    );
  }

  Stream<List<DataSnapshot>> getDateData() {
    Stream<DataSnapshot> stream1 = _database
        .reference()
        .child(PREFERENCES)
        .child(USER_PREF)
        .onValue
        .map((event) => event.snapshot);
    Stream<DataSnapshot> stream2 = _database
        .reference()
        .child(DEVICE_PREFERENCES)
        .child(USER_PREF)
        .onValue
        .map((event) => event.snapshot);
    Stream<DataSnapshot> stream3 = _database
        .reference()
        .child(UPDATE_INFO)
        .child(USER_PREF)
        .onValue
        .map((event) => event.snapshot);
    return CombineLatestStream.list([
      stream1,
      stream2,
      stream3,
    ]);
  }
}
