import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_form.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;

  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInForm(
            auth: auth,
          )),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
