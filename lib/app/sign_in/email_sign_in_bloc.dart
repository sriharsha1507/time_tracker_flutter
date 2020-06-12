import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController();

  EmailSignInModel _model = EmailSignInModel();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(
      isSubmitted: true,
      isLoading: true,
    );
    try {
      (_model.formType == EmailSignInFormType.signIn)
          ? await auth.signInWithEmailAndPassword(_model.email, _model.password)
          : await auth.createUserWithEmailAndPassword(
              _model.email, _model.password);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: _model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      isSubmitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      isSubmitted: isSubmitted,
    );

    _modelController.add(_model);
  }
}
