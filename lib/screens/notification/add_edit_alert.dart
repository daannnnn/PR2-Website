import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/constants.dart';
import 'package:pr2/models/factor.dart';
import 'package:pr2/screens/notification/factor_card.dart';

class AddEditAlert extends StatefulWidget {
  const AddEditAlert(
      {Key? key, required this.add, this.factor, this.onIncrease, this.value})
      : title = add ? 'Add Alert' : 'Edit Alert',
        super(key: key);

  final bool add;
  final String title;

  final Factor? factor;
  final bool? onIncrease;
  final double? value;

  @override
  _AddEditAlertState createState() => _AddEditAlertState();
}

class _AddEditAlertState extends State<AddEditAlert> {
  Factor? factor;
  final valueController = TextEditingController();
  bool? onIncrease;

  final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    super.initState();
    factor = widget.factor;
    onIncrease = widget.onIncrease;
    valueController.text = ((widget.value ?? 0) / (factor?.divider ?? 1))
        .toString()
        .replaceAll(regex, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () async {
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
                final ref = FirebaseDatabase.instance
                    .reference()
                    .child(PREFERENCES)
                    .child(ALERTS);
                final key = ref.push().key;

                int count = 0;
                await ref
                    .update({
                      DATE: ServerValue.timestamp,
                      '$LIST/$key': {
                        FACTOR: factor?.key,
                        VALUE: (int.tryParse(valueController.text) ?? 0) *
                            (factor?.divider ?? 1),
                        ON_INCREASE: onIncrease
                      }
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
          title:
              Text(widget.title, style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
          backgroundColor: const Color(0xFFF8F9FB),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredGrid.count(
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                crossAxisCount: 2,
                children: List.generate(factorMap.length, (index) {
                  Factor a = factorMap.values.elementAt(index);
                  return FactorCard(
                    factor: a,
                    selected: a == factor,
                    onTap: () {
                      setState(() {
                        factor = a != factor ? a : null;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 24.0),
              Divider(height: 1.0, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          onIncrease = onIncrease ?? false ? null : true;
                        });
                      },
                      child: CustomCard(
                        color: onIncrease ?? false
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(40)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_drop_up,
                                color: Color(0xFF00FF88),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Above'.toUpperCase(),
                                style: Theme.of(context).textTheme.button,
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          onIncrease = onIncrease ?? true ? false : null;
                        });
                      },
                      child: CustomCard(
                        color: onIncrease ?? true
                            ? Colors.white
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(40),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFFFF6161),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Below'.toUpperCase(),
                                style: Theme.of(context).textTheme.button,
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Value',
                  suffixText: factor?.sign ?? '',
                ),
                keyboardType: TextInputType.number,
                controller: valueController,
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }
}
