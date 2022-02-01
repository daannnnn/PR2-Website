import 'package:firebase_auth/firebase_auth.dart';
import 'package:pr2/models/user_state.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserState> get user {
    return _auth.authStateChanges().map((user) {
      return UserState(user: user, loading: false);
    });
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
