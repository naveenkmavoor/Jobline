import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PhoneNumberValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  /// {@macro password}
  const PhoneNumber.pure([String value = '']) : super.pure(value);

  /// {@macro password}
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneNumberValidationError? validator(String? value) {
    return value == null || value.isEmpty
        ? PhoneNumberValidationError.invalid
        : null;
  }
}
