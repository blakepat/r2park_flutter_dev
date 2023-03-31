import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../auth/auth_utilities/auth_credentials.dart';
import '../auth/auth_utilities/auth_repo.dart';
import '../auth/data_repo.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo authRepo;
  final DataRepo dataRepo;

  SessionCubit({required this.authRepo, required this.dataRepo})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        print('attemptAutoLogin - user id is null');
        throw Exception();
      }
      User? user = await dataRepo.getUserByEmail(userId);

      if (user == null) {
        print('attemptAutoLogin - USER is null');
        signOut();
        emit(Unauthenticated());
      } else {
        print(user.email);
        emit(Authenticated(user: user));
      }
    } on Exception {
      print('attemptAutoLoginFailed!');
      emit(Unauthenticated());
    }
  }

  void updateLicensePlates(
      {required List<String> plates, required User user}) async {
    await dataRepo.updateSavedLicensePlates(plates: plates, user: user);
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(User user) async {
    try {
      if (user == null) {
        emit(Unauthenticated());
      } else {
        print(user.email);
        emit(Authenticated(user: user));
      }
    } catch (e) {
      print('show session failed');
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
