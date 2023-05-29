part of 'sign_up_cubit.dart';

enum PasswordError {
  empty,
  bothtrue,
  onetrueotherfalse,
  othertrueonefalse,
}

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.fname = const Fname.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.passVal = PasswordError.empty,
  });

  final Email email;
  final Fname fname;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final PasswordError passVal;

  @override
  List<Object> get props => [email, fname, password, status];

  SignUpState copyWith({
    Fname? fname,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    PasswordError? passVal,
  }) {
    return SignUpState(
      email: email ?? this.email,
      fname: fname ?? this.fname,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      passVal: passVal ?? this.passVal,
    );
  }
}
