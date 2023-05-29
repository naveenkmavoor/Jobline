import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jobline/features/authentication/login/models/login_response.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/shared/data/authentication/form_inputs/email.dart';
import 'package:jobline/shared/data/authentication/form_inputs/password_login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email.valid ? email : Email.pure(value),
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void onEmailUnfocused() {
    final email = Email.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void emailPasswordChanged(String value) {
    final password = PasswordLogin.dirty(value);
    emit(
      state.copyWith(
        password: password.valid ? password : PasswordLogin.pure(value),
        status: Formz.validate([state.email, password]),
      ),
    );
  }

  void onPasswordUnfocused() {
    final password = PasswordLogin.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([password]),
      ),
    );
  }

  Future<void> logInWithCredentials(bool useEmail) async {
    final password = PasswordLogin.dirty(state.password.value);
    if (useEmail) {
      final email = Email.dirty(state.email.value);

      emit(state.copyWith(
        email: email,
        password: password,
        status: Formz.validate([email, password]),
      ));
    } else {
      emit(state.copyWith(
        email: const Email.pure(""),
        password: password,
        status: Formz.validate([password]),
      ));
    }

    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
        ));
      } catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.toString(),
            status: FormzStatus.submissionFailure,
          ),
        );
      }
    }
  }

  // Future<void> logInWithGoogle() async {
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await _authenticationRepository.logInWithGoogle();
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on LogInWithGoogleFailure catch (e) {
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.message,
  //         status: FormzStatus.submissionFailure,
  //       ),
  //     );
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
}
