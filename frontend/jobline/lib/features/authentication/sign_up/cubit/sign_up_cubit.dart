import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/shared/data/authentication/models/form_inputs/email.dart';
import 'package:jobline/shared/data/authentication/models/form_inputs/fname.dart';
import 'package:jobline/shared/data/authentication/models/form_inputs/password.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email.valid ? email : Email.pure(value),
        status: Formz.validate([
          state.fname,
          email,
          state.password,
        ]),
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

  void fnameChanged(String value) {
    final fname = Fname.dirty(value);
    emit(
      state.copyWith(
        fname: fname.valid ? fname : Fname.pure(value),
        status: Formz.validate([
          fname,
          state.email,
          state.password,
        ]),
      ),
    );
  }

  void onFnameUnfocused() {
    final firstname = Fname.dirty(state.fname.value);
    emit(
      state.copyWith(
        fname: firstname,
        status: Formz.validate([firstname, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    var passval = PasswordError.empty;

    final _passwordAlphaNumeric = RegExp(r'(?=.*[0-9])(?=.*[a-zA-Z]).{1,}$');
    if (value.length >= 6 && value.length <= 20) {
      if (_passwordAlphaNumeric.hasMatch(value)) {
        passval = PasswordError.bothtrue;
      } else {
        passval = PasswordError.onetrueotherfalse;
      }
    } else if (_passwordAlphaNumeric.hasMatch(value)) {
      if (value.length >= 6 && value.length <= 20) {
        passval = PasswordError.bothtrue;
      } else {
        passval = PasswordError.othertrueonefalse;
      }
    }
    emit(
      state.copyWith(
        passVal: passval,
        password: password,
        status: Formz.validate([
          state.fname,
          state.email,
          password,
        ]),
      ),
    );
  }

  void onPasswordFocused() {
    const password = Password.pure("1");
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          state.fname,
          state.email,
          password,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted(String accType) async {
    final fname = Fname.dirty(state.fname.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(fname: fname, email: email, password: password));

    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        fname: state.fname.value,
        eMail: state.email.value,
        role: accType,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
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
