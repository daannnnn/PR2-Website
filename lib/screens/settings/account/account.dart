import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pr2/screens/authenticate/authenticate.dart';
import 'package:pr2/screens/wrapper.dart';
import 'package:pr2/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late DatabaseReference baseDatabaseRef;
  final AuthService _auth = AuthService();

  late ScrollController scrollController;
  bool isScrolledToTop = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    baseDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child((user?.uid ?? '') + '/' + DATA);

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
        title: Text('Account', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: isScrolledToTop ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email'.toUpperCase(),
                style: Theme.of(context).textTheme.overline,
              ),
              Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 16.0),
              Divider(height: 1.0, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16.0),
              OutlinedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 16.0),
                              Text('Signing out'),
                            ],
                          ));
                        });

                    final key = await _getTokenKey();
                    if (key != null) {
                      DatabaseReference ref =
                          baseDatabaseRef.child(PREFERENCES).child(TOKENS);
                      await ref.update(
                          {'$LIST/$key': null, DATE: ServerValue.timestamp});
                    }
                    await _removeTokenKey();
                    await _removeLastTokenRefreshTime();
                    await FirebaseMessaging.instance.deleteToken();
                    await _auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Wrapper()),
                        (route) => false);
                  },
                  child: Text(
                    'Sign out'.toUpperCase(),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getTokenKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('fcmTokenKey');
  }

  Future<void> _removeTokenKey() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('fcmTokenKey');
  }

  Future<void> _removeLastTokenRefreshTime() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('lastTokenRefreshTime');
  }
}
