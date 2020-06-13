import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_page.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_button.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_manager.dart';
import 'package:timetrackerfluttercourse/app/sign_in/social_sign_in_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, child) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in error',
      exception: exception,
    ).show(context);
  }

  void _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code != 'ERROR_ABORTED_BY_USER') _showSignInError(context, e);
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code != 'ERROR_ABORTED_BY_USER') _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) {
            return EmailSignInPage();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with google',
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with facebook',
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
              text: 'Sign in with email',
              color: Colors.teal[700],
              textColor: Colors.white,
              onPressed: isLoading ? null : () => _signInWithEmail(context)),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime[300],
            textColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return CircularProgressIndicator();
    } else {
      return Text(
        'Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      );
    }
  }
}
