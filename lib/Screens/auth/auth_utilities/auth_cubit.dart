import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Session/session_cubit.dart';
import 'auth_credentials.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit, required this.credentials})
      : super(AuthState.login);
  AuthCredentials credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp(
      {required String email,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String password}) {
    credentials = AuthCredentials(
        // firstName: firstName,
        // lastName: lastName,
        // phoneNumber: phoneNumber,
        email: email,
        password: password);
    emit(AuthState.confirmSignUp);
  }

  // void launchSession(AuthCredentials authCredentials) {
  //   sessionCubit.showSession();
  // }
}
