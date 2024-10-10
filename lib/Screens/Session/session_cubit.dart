import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../auth/auth_utilities/auth_repo.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo authRepo;
  List<City>? cities;
  List<Role>? roles;
  final databaseManager = DatabaseManager();
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  SessionCubit({required this.authRepo, this.cities, this.roles})
      : super(Unauthenticated()) {
    attemptAutoLogin();
  }

  //MARK: - Auth Methods
  void showAuth() => emit(Unauthenticated());

  void showSession(User user) async {
    try {
      if (user.email != null) {
        final SharedPreferences prefs = await preferences;
        await prefs.setString('email', user.email!);
        emit(Authenticated(user: user));
      }
    } catch (e) {
      print(e);
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('password');
    prefs.remove('email');
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    print("ATTEMPT AUTO LOGIN CALLED");
    final SharedPreferences prefs = await preferences;
    String? userEmail = prefs.getString('email');
    String? userPassword = prefs.getString('password');
    User? user;
    if (userEmail != null && userPassword != null) {
      user = await databaseManager.login(userEmail, userPassword);
      try {
        if (user == null) {
          emit(Unauthenticated());
        } else {
          showSession(user);
          emit(Authenticated(user: user));
        }
      } on Exception {
        emit(Unauthenticated());
      }
    } else {
      return;
    }
  }
}
