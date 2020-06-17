import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_change_model.dart';
import 'package:timetrackerfluttercourse/common_widgets/form_submit_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: ListenableProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
          builder: (context, model, _) => EmailSignInFormChangeNotifier(
            model: model,
          ),
        ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  EmailSignInChangeModel get model => widget.model;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  void _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print(e.toString());
      PlatformExceptionAlertDialog(
        title: "Sign in error",
        exception: e,
      ).show(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
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
        text: model.primaryText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryText),
        onPressed: model.isLoading ? null : _toggleForm,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: 'Password', errorText: model.passwordErrorText),
      enabled: model.isLoading == false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText),
      enabled: model.isLoading == false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
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
    var newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
