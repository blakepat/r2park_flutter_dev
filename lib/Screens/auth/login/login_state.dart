import '../form_submission_state.dart';

class LoginState {
  final String email;
  bool get isValidUsername {
    return email.length > 3 && email.contains('@');
  }

  final String password;
  bool get isValidPassword => password.length > 6;
  final FormSubmissionStatus formStatus;

  LoginState(
      {this.email = '',
      this.password = '',
      this.formStatus = const InitialFormStatus()});

  LoginState copyWith(
      {String? email, String? password, FormSubmissionStatus? formStatus}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
