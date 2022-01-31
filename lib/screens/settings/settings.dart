import 'package:flutter/material.dart';
import 'package:pr2/screens/settings/account/account.dart';
import 'package:pr2/screens/settings/notifications/notifications.dart';
import 'package:pr2/screens/settings/preferences/preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late ScrollController scrollController;
  bool isScrolledToTop = true;

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
        ),
        title: Text('Settings', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Preferences()));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.tune_outlined),
                    const SizedBox(width: 16.0),
                    Text(
                      "Preferences",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_outlined),
                    const SizedBox(width: 16.0),
                    Text(
                      "Notifications",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Account()));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle_outlined),
                    const SizedBox(width: 16.0),
                    Text(
                      "Account",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
