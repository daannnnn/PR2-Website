import 'package:firebase_auth/firebase_auth.dart';

class UserState {
  User? user;
  bool loading;
  UserState({required this.user, required this.loading});
}
