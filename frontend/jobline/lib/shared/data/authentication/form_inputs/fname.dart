import 'package:formz/formz.dart';

enum FnameValidationError { invalid }

class Fname extends FormzInput<String, FnameValidationError> {
  const Fname.pure([String value = '']) : super.pure(value);
  const Fname.dirty([String value = '']) : super.dirty(value);

  @override
  FnameValidationError? validator(String? value) {
    return value != "" ? null : FnameValidationError.invalid;
  }
}
