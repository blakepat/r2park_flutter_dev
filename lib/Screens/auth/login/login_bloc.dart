import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_utilities/auth_cubit.dart';
import '../auth_utilities/auth_repo.dart';
import '../form_submission_state.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo authRepo;
  final AuthCubit authCubit;

  LoginBloc({required this.authRepo, required this.authCubit})
      : super(LoginState()) {
    on<LoginEvent>(_onEvent);
  }

  Future<void> _onEvent(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginUsernameChanged) {
      emit(state.copyWith(email: event.username));
    }
    // password update
    else if (event is LoginPasswordChanged) {
      emit(state.copyWith(password: event.password));
    }
    //form submitted
    else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        // final userId = await authRepo.login(
        //   email: state.email,
        //   password: state.password,
        // );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        // authCubit.launchSession(AuthCredentials(
        //   email: state.email,
        //   userId: userId,
        // ));
      } catch (e) {
        print('error on login bloc: $e');
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    }
  }
}
