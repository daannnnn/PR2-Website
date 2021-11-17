import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pr2/models/current.dart';
import 'package:pr2/models/current_stream_publisher.dart';
import 'package:pr2/screens/past_data/past_data.dart';
import 'package:pr2/services/auth_service.dart';
import 'past_data_summary.dart';
import 'realtime_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthService _auth = AuthService();

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  Stream<Current>? currentStream;

  @override
  void initState() {
    super.initState();
    currentStream = CurrentStreamPublisher().getCurrentStream();
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
          TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()],
                      ));
                    });
                await _auth.signOut();
                Navigator.pop(context);
              },
              child: const Text('Sign Out'))
        ],
        title: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              RealtimeData(
                stream: currentStream,
                intervalSeconds: 2, // TODO: Retrieve from database
                pastMinuteValueToShow: kIsWeb ? 5 : 1,
              ),
              const SizedBox(height: 48.0),
              Divider(height: 1.0, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 48.0),
              PastDataSummary(
                goToPastData: () async {
                  setState(() {
                    currentStream = null;
                  });
                  currentStream = null;
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PastData()));
                  // TODO: Check if element already exists.
                  setState(() {
                    currentStream = CurrentStreamPublisher().getCurrentStream();
                  });
                },
              ),
            ],
          ),
        ),
        controller: scrollController,
      ),
    );
  }

  @override
  void dispose() {
    setState(() {
      currentStream = null;
    });
    super.dispose();
  }
}
