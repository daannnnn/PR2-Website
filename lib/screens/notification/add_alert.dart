import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pr2/constants.dart';
import 'package:pr2/models/factor.dart';

class AddAlert extends StatefulWidget {
  const AddAlert({Key? key}) : super(key: key);

  @override
  _AddAlertState createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  String? dropdownFactorValue;
  final valueController = TextEditingController();
  bool onIncrease = false;

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
                        FACTOR: dropdownFactorValue,
                        VALUE: int.tryParse(valueController.text) ?? 0,
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
          title: Text('Create New Alert',
              style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Factor'),
                trailing: DropdownButton<String>(
                  value: dropdownFactorValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownFactorValue = newValue!;
                    });
                  },
                  items: <Factor>[
                    Factor.airHumidity,
                    Factor.airTemperature,
                    Factor.soilTemperature,
                    Factor.soilMoisture,
                    Factor.light
                  ].map<DropdownMenuItem<String>>((Factor value) {
                    return DropdownMenuItem<String>(
                      value: value.key,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter value',
                ),
                keyboardType: TextInputType.number,
                controller: valueController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              ListTile(
                title: const Text('On increase'),
                trailing: Switch(
                    value: onIncrease,
                    onChanged: (value) {
                      setState(() {
                        onIncrease = value;
                      });
                    }),
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
