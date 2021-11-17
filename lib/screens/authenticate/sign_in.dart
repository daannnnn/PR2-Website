import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr2/services/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Wrap(children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
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
                        User? user = await _auth.signInWithEmailAndPassword(
                            email, password);

                        Navigator.pop(context);

                        if (user == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('Error'),
                                );
                              });
                        }
                      },
                      child: Text('Sign In'.toUpperCase())),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
