
import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/app/home_page.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_page.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  const LandingPage({Key key, @required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth
            );
          }
          return HomePage(auth: auth);
        } else
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }
}
