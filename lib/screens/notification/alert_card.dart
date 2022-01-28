import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/models/alert.dart';
import 'package:pr2/models/factor.dart';

import '../../constants.dart';
import 'add_edit_alert.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({Key? key, required this.alert, required this.database})
      : super(key: key);

  final FirebaseDatabase database;
  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomCard(
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
                  style: Theme.of(context).textTheme.bodyText1,
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
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditAlert(
                              add: false,
                              id: alert.id,
                              factor: alert.factor,
                              onIncrease: alert.onIncrease,
                              value: alert.value.toDouble(),
                            )));
              },
              onLongPress: () {
                AlertDialog alertDialogDeleting = AlertDialog(
                    content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                    Text('Deleting'),
                  ],
                ));
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text("Delete Alert?"),
                      content: Text(
                          "Alert when ${alert.factor.name} goes ${alert.onIncrease ? 'above' : 'below'} ${alert.value / alert.factor.divider}${alert.factor.sign}."),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () async {
                            showDialog(
                                context: dialogContext,
                                builder: (context) {
                                  return alertDialogDeleting;
                                });
                            final ref = database
                                .reference()
                                .child(PREFERENCES)
                                .child(ALERTS);
                            await ref.update({
                              DATE: ServerValue.timestamp,
                              '$LIST/${alert.id}': null,
                            });
                            int count = 0;
                            Navigator.popUntil(dialogContext, (route) {
                              return count++ == 2;
                            });
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
