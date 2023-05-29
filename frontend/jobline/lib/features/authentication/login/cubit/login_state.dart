part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.phoneNumber = "",
    this.password = const PasswordLogin.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.showTextFieldErr = true,
    this.loginResponse,
  });

  final Email email;
  final String phoneNumber;
  final PasswordLogin password;
  final FormzStatus status;
  final String? errorMessage;
  final bool showTextFieldErr;
  final LoginResponse? loginResponse;

  @override
  List<Object> get props => [
        email,
        password,
        phoneNumber,
        status,
      ];

  LoginState copyWith({
    Email? email,
    String? phoneNumber,
    PasswordLogin? password,
    FormzStatus? status,
    String? errorMessage,
    bool? showTextFieldErr,
    LoginResponse? loginResponse,
  }) {
    return LoginState(
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        showTextFieldErr: showTextFieldErr ?? this.showTextFieldErr,
        loginResponse: loginResponse ?? this.loginResponse);
  }
}
