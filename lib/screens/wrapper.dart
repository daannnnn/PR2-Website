import 'package:flutter/material.dart';
import 'package:pr2/models/user_state.dart';
import 'package:pr2/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    if (userState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (userState.user == null) {
      return const Authenticate();
    } else {
      return const Dashboard(title: "PR2");
    }
  }
}
