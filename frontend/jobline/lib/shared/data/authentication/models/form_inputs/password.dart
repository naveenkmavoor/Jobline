import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  empty,

  //cases for true

  onetrueotherfalse,
  othertrueonefalse,
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure([String value = '']) : super.pure(value);

  /// {@macro password}
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordAlphaNumeric =
      RegExp(r'(?=.*[0-9])(?=.*[a-zA-Z]).{1,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    }
    // } else if (value.length >= 6 && value.length <= 20) {
    //   if (!_passwordAlphaNumeric.hasMatch(value)) {
    //     return PasswordValidationError.onetrueotherfalse;
    //   }
    // } else if (_passwordAlphaNumeric.hasMatch(value)) {
    //   if (!(value.length >= 6 && value.length <= 20)) {
    //     return PasswordValidationError.othertrueonefalse;
    //   }
    // }

    return null;
  }
}
