import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum OtpValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class OtpNumber extends FormzInput<String, OtpValidationError> {
  /// {@macro password}
  const OtpNumber.pure() : super.pure('');

  /// {@macro password}
  const OtpNumber.dirty([String value = '']) : super.dirty(value);

  static final _phoneRegExp = RegExp(r'^[0-9]{4}$');

  @override
  OtpValidationError? validator(String? value) {
    return _phoneRegExp.hasMatch(value ?? "")
        ? null
        : OtpValidationError.invalid;
  }
}
