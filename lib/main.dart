import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/landing_page.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (BuildContext context) => Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: LandingPage(),
      ),
    );
  }
}
