import 'package:flutter/foundation.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_model.dart';
import 'package:timetrackerfluttercourse/app/sign_in/validators.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool isSubmitted;

  String get primaryText =>
      formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

  String get secondaryText => formType == EmailSignInFormType.signIn
      ? 'Need an account? Register'
      : 'Have an account? Sign in';

  bool get canSubmit =>
      emailValidator.isValid(email) &&
      emailValidator.isValid(password) &&
      !isLoading;

  String get passwordErrorText {
    bool showErrorText = isSubmitted && !passwordValidator.isValid(password);

    return showErrorText ? invalidEmailValidationText : null;
  }

  String get emailErrorText {
    bool showErrorText = isSubmitted && !emailValidator.isValid(email);

    return showErrorText ? invalidEmailValidationText : null;
  }

  Future<void> submit() async {
    updateWith(
      isSubmitted: true,
      isLoading: true,
    );
    try {
      (this.formType == EmailSignInFormType.signIn)
          ? await auth.signInWithEmailAndPassword(this.email, this.password)
          : await auth.createUserWithEmailAndPassword(
              this.email, this.password);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: this.formType == EmailSignInFormType.signIn
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }
}
