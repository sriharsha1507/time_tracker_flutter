import 'package:timetrackerfluttercourse/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool isSubmitted;

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

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) =>
      EmailSignInModel(
        email: email ?? this.email,
        password: password ?? this.password,
        formType: formType ?? this.formType,
        isLoading: isLoading ?? this.isLoading,
        isSubmitted: isSubmitted ?? this.isSubmitted,
      );
}
