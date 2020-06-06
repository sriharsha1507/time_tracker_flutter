import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/sign_in/validators.dart';
import 'package:timetrackerfluttercourse/common_widgets/form_submit_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      _formType == EmailSignInFormType.signIn
          ? await auth.signInWithEmailAndPassword(_email, _password)
          : await auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      PlatformAlertDialog(
        title: "Sign in error",
        content: e.toString(),
        defaultActionText: "Ok",
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    print('email : $_email, password : $_password');
  }

  void _toggleForm() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final String primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';
    final String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _isLoading ? null : _toggleForm,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidEmailValidationText : null),
      enabled: _isLoading == false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (value) {
        _onTextValueChange();
      },
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailValidationText : null),
      enabled: _isLoading == false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (value) {
        _onTextValueChange();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _emailEditingComplete() {
    var newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _onTextValueChange() {
    setState(() {});
  }
}
