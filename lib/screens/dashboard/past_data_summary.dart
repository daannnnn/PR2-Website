import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr2/models/day_summary.dart';
import 'package:pr2/models/last_day_summary_future.dart';

import 'day_summary_card.dart';

class PastDataSummary extends StatelessWidget {
  PastDataSummary({
    Key? key,
    required this.goToPastData,
    required this.baseDatabaseRef,
  })  : lastDaySummaryFuture =
            LastDaySummaryFuture().getLastDaySummaryFuture(baseDatabaseRef),
        super(key: key);

  final DatabaseReference baseDatabaseRef;
  final Function() goToPastData;
  final Future<DaySummary?> lastDaySummaryFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Past Data".toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .overline
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 8.0),
        FutureBuilder(
            future: lastDaySummaryFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return DaySummaryCard(snapshot.data as DaySummary);
              } else if (!snapshot.hasData) {
                return const Text('No past data yet');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        const SizedBox(height: 16.0),
        TextButton.icon(
          onPressed: goToPastData,
          icon: Text('See all past data'.toUpperCase()),
          label: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
