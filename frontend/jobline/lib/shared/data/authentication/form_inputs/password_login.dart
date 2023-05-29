import 'package:formz/formz.dart';

/// Validation errors for the [Login Password] [FormzInput].
enum PasswordLoginValidationError {
  empty,
}

/// {@template Login password}
/// Form input for an password input.
/// {@endtemplate}
class PasswordLogin extends FormzInput<String, PasswordLoginValidationError> {
  /// {@macro password}
  const PasswordLogin.pure([String value = '']) : super.pure(value);

  /// {@macro password}
  const PasswordLogin.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordLoginValidationError? validator(String? value) {
    return value == null || value.isEmpty
        ? PasswordLoginValidationError.empty
        : null;
  }
}
